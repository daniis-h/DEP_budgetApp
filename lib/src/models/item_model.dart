class ExpenseItem {
  final String id;
  final String itemName;
  final String itemCategory;
  final double itemPrice;
  final DateTime itemDate;

  const ExpenseItem({
    required this.id,
    required this.itemName,
    required this.itemCategory,
    required this.itemPrice,
    required this.itemDate,
  });

  factory ExpenseItem.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = properties['Date']?['date']?['start'];
    final id = map['id'];
    final itemName = properties['Name']?['title']?[0]?['plain_text'] ?? '?';
    final itemCategory = properties['Category']?['select']?['name'] ?? 'Any';
    final itemPrice = (properties['Price']?['number'] ?? 0).toDouble();
    final itemDate = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
    return ExpenseItem(
      id: id,
      itemName: itemName,
      itemCategory: itemCategory,
      itemPrice: itemPrice,
      itemDate: itemDate,
    );
  }
}
