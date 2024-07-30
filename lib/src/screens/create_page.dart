import 'dart:convert';

import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart' as database;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  final ItemModel? item;
  final bool isEditing;

  const CreatePage({this.item, this.isEditing = false});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  var selectedCategory;
  String selectedDate = "";
  String formattedDate = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (widget.isEditing) {
      nameController.text = widget.item!.name;
      priceController.text = widget.item!.price.toString();
      selectedCategory = widget.item!.category;
      selectedDate = DateFormat('MMMM dd, yyyy').format(widget.item!.date);
      formattedDate = DateFormat('yyyy-MM-dd').format(widget.item!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BudgetProvider.of(context);
    bloc.fetchDatabase();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Expenses'),
        ),
        body: buildForm(bloc),
      ),
    );
  }

  Widget buildForm(BudgetBloc bloc) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          buildTextForm(nameController, "Name"),
          SizedBox(height: 20.0),
          buildCategoryAndDate(true, bloc),
          SizedBox(height: 20.0),
          buildTextForm(priceController, "Price"),
          SizedBox(height: 20.0),
          buildCategoryAndDate(false, bloc),
          SizedBox(height: 40.0),
          isLoading
              ? CircularProgressIndicator(color: Colors.red[400])
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => validateAndSave(bloc),
                  child: Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void validateAndSave(BudgetBloc bloc) async {
    if (nameController.text.isEmpty) {
      showSnackBar("Name is required");
      return;
    }
    if (selectedCategory == null) {
      showSnackBar("Category is required");
      return;
    }
    if (priceController.text.isEmpty) {
      showSnackBar("Price is required");
      return;
    }

    setState(() {
      isLoading = true;
    });

    var response;
    String message;

    final data = {
      "name": nameController.text,
      "price": priceController.text,
      "category": selectedCategory,
      "date": formattedDate,
      if (widget.isEditing) "pageId": widget.item!.pageId,
    };

    if (widget.isEditing) {
      message = "Data updated successfully";
      response = await bloc.editItem(data);
    } else {
      message = "Data added successfully";
      response = await bloc.addItem(data);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      bloc.fetchItems();
      showSnackBar(message);
      Navigator.of(context).pop();
    } else {
      final responseData = jsonDecode(response.body);
      throw Failure(message: responseData['message']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 3700)),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('MMMM dd, yyyy').format(picked);
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget buildTextForm(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: hint,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  Widget buildCategoryAndDate(bool isCategory, BudgetBloc bloc) {
    return Container(
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: isCategory ? buildCategoryDropdown(bloc) : buildDatePicker(),
          );
        },
      ),
    );
  }

  Widget buildDatePicker() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _selectDate(context),
      child: Text(
        selectedDate.isEmpty ? "Select Date" : selectedDate,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget buildCategoryDropdown(BudgetBloc bloc) {
    return StreamBuilder(
      stream: bloc.dataList,
      builder: (context, AsyncSnapshot<List<database.DataResult>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final failure = snapshot.error as Failure;
          return Center(child: Text(failure.message));
        } else {
          final data = snapshot.data!;
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text("Select Category"),
              value: selectedCategory,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: data[0].properties?.category?.select?.options?.map((option) {
                return DropdownMenuItem(
                  child: Text(option.name!),
                  value: option.name,
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
