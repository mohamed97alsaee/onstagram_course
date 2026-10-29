import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/main.dart';
import 'package:onstagram/screens/auth_screens/login_screen.dart';

void main() {
  testWidgets('the app starts on the login screen with the logo', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('the theme comes from the blue seed', (tester) async {
    await tester.pumpWidget(const MyApp());

    final context = tester.element(find.byType(LoginScreen));
    expect(Theme.of(context).colorScheme.primary, const Color(0xff0095F6));
  });

  testWidgets('the moon button switches the whole app to dark and back', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(LoginScreen))).brightness;

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
