import 'dart:convert';
import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/widgets/refresh.dart';
import 'package:budget_tracker_notion/src/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import 'create_page.dart';

class BudgetScreen extends StatefulWidget {
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  SlidableController? _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController();
  }

  @override
  Widget build(BuildContext context) {
    final budgetBloc = BudgetProvider.of(context);
    budgetBloc.fetchItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePage()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.add_circle_outline),
            ),
          )
        ],
      ),
      body: buildItemList(budgetBloc),
    );
  }

  Widget buildItemList(BudgetBloc budgetBloc) {
    return StreamBuilder(
      stream: budgetBloc.items,
      builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final failure = snapshot.error as Failure;
          return Center(
            child: Text(failure.message),
          );
        } else {
          List<ItemModel> items = snapshot.data!;
          List<ItemElement> itemElements = items
              .map((item) => ItemElement(item.date, item))
              .toList();

          return Column(
            children: [
              SpendingChart(items: items),
              Expanded(
                child: Refresh(
                  child: StickyGroupedListView<ItemElement, DateTime>(
                    elements: itemElements,
                    order: StickyGroupedListOrder.DESC,
                    groupBy: (ItemElement element) => DateTime(
                      element.date.year,
                      element.date.month,
                    ),
                    groupSeparatorBuilder: (ItemElement element) => Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0x45C4C4C4),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          '${getMonthName(element.date.month)} ${element.date.year}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    floatingHeader: false,
                    itemBuilder: (_, ItemElement element) {
                      return Slidable(
                        controller: _slidableController,
                        key: Key(element.item.pageId),
                        actionPane: SlidableStrechActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 2.0,
                              color: getCategoryColor(element.item.category),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(element.item.name),
                            subtitle: Text(
                              '${element.item.category} - ${DateFormat.yMd().format(element.date)}',
                            ),
                            trailing: Text(
                              '-\$${element.item.price.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.lightGreen[300],
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreatePage(
                                    itemData: element.item,
                                    isEdit: true,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red[400],
                            icon: Icons.delete,
                            onTap: () async {
                              var response = await budgetBloc
                                  .deletePage(element.item.pageId);
                              final int statusCode = response.statusCode;
                              if (statusCode == 200) {
                                budgetBloc.fetchItems();
                              } else {
                                final data = jsonDecode(response.body);
                                throw Failure(message: data['message']);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}

Widget _getActionPane(int index) {
  switch (index % 4) {
    case 0:
      return SlidableBehindActionPane();
    case 1:
      return SlidableStrechActionPane();
    case 2:
      return SlidableScrollActionPane();
    case 3:
      return SlidableDrawerActionPane();
    default:
      return SlidableBehindActionPane();
  }
}

class ItemElement implements Comparable {
  DateTime date;
  ItemModel item;

  ItemElement(this.date, this.item);

  @override
  int compareTo(other) {
    return date.compareTo(other.date);
  }
}

String getMonthName(int index) {
  const monthNames = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
  ];
  return monthNames[index - 1];
}
