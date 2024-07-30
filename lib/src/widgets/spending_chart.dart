import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChart extends StatelessWidget {
  final List<ItemModel> items;

  const SpendingChart({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spendingByCategory = <String, double>{};
    items.forEach((item) => spendingByCategory.update(
        item.category, (value) => value + item.price,
        ifAbsent: () => item.price));
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360.0,
        child: Column(
          children: [
            Expanded(child: _buildPieChart(spendingByCategory)),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: spendingByCategory.keys
                  .map((category) => _CategoryIndicator(
                        color: _getCategoryColor(category),
                        text: category,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> spendingByCategory) {
    return PieChart(
      PieChartData(
        sections: spendingByCategory
            .map((category, total) => MapEntry(
                category,
                PieChartSectionData(
                    color: _getCategoryColor(category),
                    radius: 100.0,
                    title: '\$${total.toStringAsFixed(2)}',
                    value: total)))
            .values
            .toList(),
        sectionsSpace: 0.5,
      ),
    );
  }

  Color _getCategoryColor(String category) {
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
}

class _CategoryIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const _CategoryIndicator({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
