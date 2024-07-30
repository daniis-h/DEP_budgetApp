// To parse this JSON data, do
//
//     final expenseDatabase = expenseDatabaseFromMap(jsonString);

import 'dart:convert';

ExpenseDatabase expenseDatabaseFromMap(String str) =>
    ExpenseDatabase.fromMap(json.decode(str));

String expenseDatabaseToMap(ExpenseDatabase data) => json.encode(data.toMap());

class ExpenseDatabase {
  ExpenseDatabase({
    this.type,
    this.records,
    this.cursor,
    this.hasMoreRecords,
  });

  String? type;
  List<ExpenseRecord>? records;
  dynamic cursor;
  bool? hasMoreRecords;

  factory ExpenseDatabase.fromMap(Map<String, dynamic> json) => ExpenseDatabase(
        type: json["type"] == null ? null : json["type"],
        records: json["records"] == null
            ? null
            : List<ExpenseRecord>.from(json["records"].map((x) => ExpenseRecord.fromMap(x))),
        cursor: json["cursor"],
        hasMoreRecords: json["has_more_records"] == null ? null : json["has_more_records"],
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "records": records == null
            ? null
            : List<dynamic>.from(records!.map((x) => x.toMap())),
        "cursor": cursor,
        "has_more_records": hasMoreRecords == null ? null : hasMoreRecords,
      };
}

class ExpenseRecord {
  ExpenseRecord({
    this.type,
    this.id,
    this.createdTime,
    this.lastModifiedTime,
    this.titles,
    this.attributes,
    this.source,
  });

  String? type;
  String? id;
  DateTime? createdTime;
  DateTime? lastModifiedTime;
  List<Title>? titles;
  Attributes? attributes;
  Source? source;

  factory ExpenseRecord.fromMap(Map<String, dynamic> json) => ExpenseRecord(
        type: json["type"] == null ? null : json["type"],
        id: json["id"] == null ? null : json["id"],
        createdTime: json["created_time"] == null
            ? null
            : DateTime.parse(json["created_time"]),
        lastModifiedTime: json["last_modified_time"] == null
            ? null
            : DateTime.parse(json["last_modified_time"]),
        titles: json["titles"] == null
            ? null
            : List<Title>.from(json["titles"].map((x) => Title.fromMap(x))),
        attributes: json["attributes"] == null
            ? null
            : Attributes.fromMap(json["attributes"]),
        source: json["source"] == null ? null : Source.fromMap(json["source"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "id": id == null ? null : id,
        "created_time":
            createdTime == null ? null : createdTime?.toIso8601String(),
        "last_modified_time":
            lastModifiedTime == null ? null : lastModifiedTime?.toIso8601String(),
        "titles": titles == null
            ? null
            : List<dynamic>.from(titles!.map((x) => x.toMap())),
        "attributes": attributes == null ? null : attributes?.toMap(),
        "source": source == null ? null : source?.toMap(),
      };
}

class Source {
  Source({
    this.type,
    this.workspace,
  });

  String? type;
  bool? workspace;

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        type: json["type"] == null ? null : json["type"],
        workspace: json["workspace"] == null ? null : json["workspace"],
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "workspace": workspace == null ? null : workspace,
      };
}

class Attributes {
  Attributes({
    this.category,
    this.date,
    this.price,
    this.name,
  });

  Category? category;
  RecordDate? date;
  Price? price;
  Name? name;

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        category: json["Category"] == null
            ? null
            : Category.fromMap(json["Category"]),
        date: json["Date"] == null ? null : RecordDate.fromMap(json["Date"]),
        price: json["Price"] == null ? null : Price.fromMap(json["Price"]),
        name: json["Name"] == null ? null : Name.fromMap(json["Name"]),
      );

  Map<String, dynamic> toMap() => {
        "Category": category == null ? null : category?.toMap(),
        "Date": date == null ? null : date?.toMap(),
        "Price": price == null ? null : price?.toMap(),
        "Name": name == null ? null : name?.toMap(),
      };
}

class Category {
  Category({
    this.id,
    this.type,
    this.select,
  });

  String? id;
  String? type;
  Selection? select;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        select: json["select"] == null ? null : Selection.fromMap(json["select"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "select": select == null ? null : select?.toMap(),
      };
}

class Selection {
  Selection({
    this.options,
  });

  List<Option>? options;

  factory Selection.fromMap(Map<String, dynamic> json) => Selection(
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toMap())),
      };
}

class Option {
  Option({
    this.id,
    this.name,
    this.color,
  });

  String? id;
  String? name;
  String? color;

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "color": color == null ? null : color,
      };
}

class RecordDate {
  RecordDate({
    this.id,
    this.type,
    this.date,
  });

  String? id;
  String? type;
  DateDetail? date;

  factory RecordDate.fromMap(Map<String, dynamic> json) => RecordDate(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        date: json["date"] == null ? null : DateDetail.fromMap(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "date": date == null ? null : date?.toMap(),
      };
}

class DateDetail {
  DateDetail();

  factory DateDetail.fromMap(Map<String, dynamic> json) => DateDetail();

  Map<String, dynamic> toMap() => {};
}

class Name {
  Name({
    this.id,
    this.type,
    this.title,
  });

  String? id;
  String? type;
  DateDetail? title;

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : DateDetail.fromMap(json["title"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title?.toMap(),
      };
}

class Price {
  Price({
    this.id,
    this.type,
    this.amount,
  });

  String? id;
  String? type;
  Amount? amount;

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        amount: json["amount"] == null ? null : Amount.fromMap(json["amount"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "amount": amount == null ? null : amount?.toMap(),
      };
}

class Amount {
  Amount({
    this.format,
  });

  String? format;

  factory Amount.fromMap(Map<String, dynamic> json) => Amount(
        format: json["format"] == null ? null : json["format"],
      );

  Map<String, dynamic> toMap() => {
        "format": format == null ? null : format,
      };
}

class Title {
  Title({
    this.type,
    this.text,
    this.annotations,
    this.plainText,
    this.href,
  });

  String? type;
  Text? text;
  Annotations? annotations;
  String? plainText;
  dynamic href;

  factory Title.fromMap(Map<String, dynamic> json) => Title(
        type: json["type"] == null ? null : json["type"],
        text: json["text"] == null ? null : Text.fromMap(json["text"]),
        annotations: json["annotations"] == null
            ? null
            : Annotations.fromMap(json["annotations"]),
        plainText: json["plain_text"] == null ? null : json["plain_text"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "text": text == null ? null : text?.toMap(),
        "annotations": annotations == null ? null : annotations?.toMap(),
        "plain_text": plainText == null ? null : plainText,
        "href": href,
      };
}

class Annotations {
  Annotations({
    this.bold,
    this.italic,
    this.strikethrough,
    this.underline,
    this.code,
    this.color,
  });

  bool? bold;
  bool? italic;
  bool? strikethrough;
  bool? underline;
  bool? code;
  String? color;

  factory Annotations.fromMap(Map<String, dynamic> json) => Annotations(
        bold: json["bold"] == null ? null : json["bold"],
        italic: json["italic"] == null ? null : json["italic"],
        strikethrough:
            json["strikethrough"] == null ? null : json["strikethrough"],
        underline: json["underline"] == null ? null : json["underline"],
        code: json["code"] == null ? null : json["code"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toMap() => {
        "bold": bold == null ? null : bold,
        "italic": italic == null ? null : italic,
        "strikethrough": strikethrough == null ? null : strikethrough,
        "underline": underline == null ? null : underline,
        "code": code == null ? null : code,
        "color": color == null ? null : color,
      };
}

class Text {
  Text({
    this.content,
    this.link,
  });

  String? content;
  dynamic link;

  factory Text.fromMap(Map<String, dynamic> json) => Text(
        content: json["content"] == null ? null : json["content"],
        link: json["link"],
      );

  Map<String, dynamic> toMap() => {
        "content": content == null ? null : content,
        "link": link,
      };
}
