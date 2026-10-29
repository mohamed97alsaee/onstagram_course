import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/main.dart';

/// Starts the app and lets the splash (logo fades in and out,
/// about 3.6 s) hand over to the ScreenRouter.
Future<void> pumpUntilRouter(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  while (find.byType(ScreenRouter).evaluate().isEmpty) {
    await tester.pump(Duration(milliseconds: 100));
  }
}

/// [pumpUntilRouter], then waits until nothing moves any more.
Future<void> pumpApp(WidgetTester tester) async {
  await pumpUntilRouter(tester);
  await tester.pumpAndSettle();
}

/// A text field found by its hint ("Email", "Password"...).
Finder fieldWithHint(String hint) => find.widgetWithText(TextFormField, hint);
