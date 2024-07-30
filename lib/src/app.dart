import 'package:budget_tracker_notion/src/screens/budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BudgetProvider(
      key: Key('budgetProviderKey'),
      child: MaterialApp(
        title: 'Budget App',
        theme: ThemeData(primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: BudgetScreen(),
      ),
    );
  }
}
