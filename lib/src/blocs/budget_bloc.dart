import 'dart:async';

import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart';
import 'package:rxdart/rxdart.dart';
import '../repositories/budget_repository.dart';

class BudgetBloc {
  final _repo = BudgetRepository();
  final _itemStreamController = BehaviorSubject<List<ItemModel>>();
  final _dataStreamController = BehaviorSubject<List<DataResult>>();

  // Streams getters
  Stream<List<ItemModel>> get itemsStream => _itemStreamController.stream;

  // Streams getters
  Stream<List<DataResult>> get dataStream => _dataStreamController.stream;

  getItems() async {
    _itemStreamController.add(await _repo.getItems());
  }

  getDatabase() async {
    _dataStreamController.add(await _repo.getDatabase());
  }

  addItem(Map<String, dynamic> itemData) async {
    return await _repo.addItems(itemData);
  }

  editItem(Map<String, dynamic> itemData) async {
    return await _repo.editItems(itemData);
  }

  deleteItem(String itemId) async {
    return await _repo.deletePage(itemId);
  }

  dispose() {
    _itemStreamController.close();
    _dataStreamController.close();
  }
}
