import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/main.dart';
import 'package:onstagram/screens/main_screens/tabs_content/home_screen.dart';

void main() {
  testWidgets('the app starts on the home screen with the logo', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('the theme comes from the blue seed', (tester) async {
    await tester.pumpWidget(const MyApp());

    final context = tester.element(find.byType(HomeScreen));
    expect(Theme.of(context).colorScheme.primary, const Color(0xff0095F6));
  });
}
