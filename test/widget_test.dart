import 'package:budget_tracker_notion/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test if BudgetScreen is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that the BudgetScreen is displayed.
    expect(find.byType(BudgetScreen), findsOneWidget);

    // Verify that the AppBar title is 'Budget Tracker'.
    expect(find.text('Budget Tracker'), findsOneWidget);
  });
}
