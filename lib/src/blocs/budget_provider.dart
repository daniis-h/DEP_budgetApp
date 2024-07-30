import 'package:flutter/material.dart';
import './budget_bloc.dart';
export './budget_bloc.dart';

class BudgetProvider extends InheritedWidget {
  final BudgetBloc budgetBloc;

  BudgetProvider({required Key key, required Widget child})
      : budgetBloc = BudgetBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BudgetBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BudgetProvider>()!.budgetBloc;
  }
}
