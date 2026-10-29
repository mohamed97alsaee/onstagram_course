import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/main.dart';
import 'package:onstagram/screens/auth_screens/login_screen.dart';
import 'package:onstagram/screens/handling_screens/splash_screen.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('the app opens on the splash, then the login screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text("Alsaee.dev"), findsOneWidget);

    await tester.pump(Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('the theme comes from the blue seed', (tester) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(LoginScreen));
    expect(Theme.of(context).colorScheme.primary, const Color(0xff0095F6));
  });

  testWidgets('the moon button switches the whole app to dark and back', (
    tester,
  ) async {
    await pumpApp(tester);
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
