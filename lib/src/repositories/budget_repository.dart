import 'dart:io';
import 'dart:convert';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart';
import 'package:http/http.dart';

class BudgetRepository {
  final String _apiBaseUrl = 'https://api.notion.com/v1';
  final Client _httpClient;
  final String _apiKey;
  final String _databaseId;

  BudgetRepository({
    Client? client,
    required String apiKey,
    required String databaseId,
  })  : _httpClient = client ?? Client(),
        _apiKey = apiKey,
        _databaseId = databaseId;

  /// Fetches all items from the Notion database and returns them as a sorted list of [ItemModel].
  Future<List<ItemModel>> fetchItems() async {
    try {
      final url = '$_apiBaseUrl/databases/$_databaseId/query';
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          'Notion-Version': '2021-05-13',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((e) => ItemModel.fromMap(e))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw Failure(message: "Error fetching items (${response.statusCode})");
      }
    } catch (e) {
      throw Failure(message: 'Failed to fetch items: ${e.toString()}');
    }
  }

  /// Fetches all databases from Notion and returns them as a list of [DataResult].
  Future<List<DataResult>> fetchDatabases() async {
    try {
      final url = '$_apiBaseUrl/databases';
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          'Notion-Version': '2021-05-13',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((e) => DataResult.fromMap(e))
            .toList();
      } else {
        throw Failure(message: "Error fetching databases (${response.statusCode})");
      }
    } catch (e) {
      throw Failure(message: 'Failed to fetch databases: ${e.toString()}');
    }
  }

  /// Adds a new item to the Notion database.
  Future<Response> createItem(Map<String, dynamic> itemData) async {
    try {
      final url = '$_apiBaseUrl/pages/';
      var body = {
        "parent": {"database_id": _databaseId},
        "properties": {
          "Name": {
            "title": [
              {"text": {"content": itemData['name']}}
            ]
          },
          "Category": {
            "select": {"name": itemData['category']}
          },
          "Date": {
            "date": {"start": itemData['date']}
          },
          "Price": {"number": double.parse(itemData['price'])}
        }
      };

      final response = await _httpClient.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Notion-Version': '2021-05-13',
        },
        body: json.encode(body),
      );

      return response;
    } catch (e) {
      throw Failure(message: 'Failed to add item: ${e.toString()}');
    }
  }

  /// Edits an existing item in the Notion database.
  Future<Response> updateItem(Map<String, dynamic> itemData) async {
    try {
      final url = '$_apiBaseUrl/pages/${itemData['pageId']}';
      var body = {
        "properties": {
          "Name": {
            "title": [
              {"text": {"content": itemData['name']}}
            ]
          },
          "Category": {
            "select": {"name": itemData['category']}
          },
          "Date": {
            "date": {"start": itemData['date']}
          },
          "Price": {"number": double.parse(itemData['price'])}
        }
      };

      final response = await _httpClient.patch(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Notion-Version': '2021-07-27',
        },
        body: json.encode(body),
      );

      return response;
    } catch (e) {
      throw Failure(message: 'Failed to update item: ${e.toString()}');
    }
  }

  /// Deletes a page by archiving it.
  Future<Response> archivePage(String pageId) async {
    try {
      final url = '$_apiBaseUrl/pages/$pageId';
      final response = await _httpClient.patch(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Notion-Version': '2021-05-13',
        },
        body: json.encode({"archived": true}),
      );

      return response;
    } catch (e) {
      throw Failure(message: 'Failed to archive page: ${e.toString()}');
    }
  }

  /// Disposes the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}
