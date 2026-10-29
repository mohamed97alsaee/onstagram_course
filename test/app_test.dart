import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
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

  testWidgets('home says whether the student key arrived', (tester) async {
    await tester.pumpWidget(const MyApp());

    // flutter test: missing. With --dart-define=STUDENT_API_KEY=...: loaded.
    expect(
      find.text(
        studentApiKey.isEmpty
            ? "Student key: missing (see README)"
            : "Student key: loaded",
      ),
      findsOneWidget,
    );
  });

  testWidgets('the moon button switches the whole app to dark and back', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(HomeScreen))).brightness;

    expect(brightness(), Brightness.light);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode_outlined));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
  });
}
