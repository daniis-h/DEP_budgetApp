import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:flutter/material.dart';

class Refresh extends StatelessWidget {
  final Widget content;

  Refresh({required this.content});

  @override
  Widget build(BuildContext context) {
    final bloc = BudgetProvider.of(context);
    return RefreshIndicator(
      child: content,
      onRefresh: () async {
        await bloc.fetchItems();
      },
    );
  }
}
