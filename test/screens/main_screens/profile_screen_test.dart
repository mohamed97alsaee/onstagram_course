import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/screens/main_screens/tabs_content/profile_screen.dart';
import 'package:onstagram/widgets/statics/titled_value.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/fake_server.dart';
import '../../helpers/test_app.dart';

/// Opens the app signed in as Sara; [me] answers every /api/auth/me.
Future<List<String>> pumpProfile(
  WidgetTester tester, {
  Map<String, dynamic> Function()? me,
}) async {
  FlutterSecureStorage.setMockInitialValues({"user_token": "1|fake-token"});
  final paths = <String>[];

  await http.runWithClient(
    () => pumpApp(tester),
    () => fakeServer((request) async {
      paths.add(request.url.path);
      return jsonResponse(me == null ? meAnswer() : me());
    }),
  );
  expect(find.byType(ProfileScreen), findsOneWidget);
  return paths;
}

void main() {
  testWidgets('the header: username, initial, counts and name', (tester) async {
    await pumpProfile(tester);

    expect(find.text("sara_ahmed"), findsOneWidget);
    expect(find.text("S"), findsOneWidget);
    expect(find.text("Sara Ahmed"), findsOneWidget);
    expect(find.byType(TitledValue), findsNWidgets(3));
    expect(find.text("12"), findsOneWidget);
    expect(find.text("180"), findsOneWidget);
    expect(find.text("75"), findsOneWidget);
    expect(find.text("No posts yet"), findsOneWidget);
  });

  testWidgets('a bio shows under the name', (tester) async {
    await pumpProfile(
      tester,
      me: () => {
        "message": "ok",
        "data": {...saraJson(), "bio": "Flutter learner from Amman"},
      },
    );

    expect(find.text("Flutter learner from Amman"), findsOneWidget);
  });

  testWidgets('opening the profile asks for fresh numbers (getMe)', (
    tester,
  ) async {
    var meCalls = 0;
    final paths = await pumpProfile(
      tester,
      me: () {
        meCalls++;
        final json = saraJson();
        // The second answer (from getMe) has one more follower.
        if (meCalls > 1) json["stats"]["followers_count"] = 181;
        return {"message": "ok", "data": json};
      },
    );

    expect(paths.where((path) => path == "/api/auth/me").length, 2);
    expect(find.text("181"), findsOneWidget);
  });

  testWidgets('Cancel closes the dialog and keeps you signed in', (
    tester,
  ) async {
    await pumpProfile(tester);

    await tester.tap(find.text("Log out"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Cancel"));
    await tester.pumpAndSettle();

    expect(find.text("Log out of Onstagram?"), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('the small square switches dark mode here too', (tester) async {
    await pumpProfile(tester);
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(ProfileScreen))).brightness;

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(brightness(), Brightness.dark);
  });
}
