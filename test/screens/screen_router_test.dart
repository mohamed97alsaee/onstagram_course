import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/screens/auth_screens/login_screen.dart';
import 'package:onstagram/screens/handling_screens/loading_screen.dart';
import 'package:onstagram/screens/main_screens/tabs_content/profile_screen.dart';

import '../helpers/fake_data.dart';
import '../helpers/fake_server.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('no saved token: the login screen', (tester) async {
    await pumpApp(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('a saved token that still works: the profile', (tester) async {
    FlutterSecureStorage.setMockInitialValues({"user_token": "1|fake-token"});

    await http.runWithClient(
      () => pumpApp(tester),
      () => fakeServer((request) async => jsonResponse(meAnswer())),
    );

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text("sara_ahmed"), findsOneWidget);
  });

  testWidgets('while /api/auth/me is on its way: the loading screen', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({"user_token": "1|fake-token"});

    await http.runWithClient(
      () async {
        await pumpUntilRouter(tester);
        expect(find.byType(LoadingScreen), findsOneWidget);

        await tester.pump(Duration(seconds: 2));
        await tester.pumpAndSettle();
        // The profile asks /api/auth/me again (getMe): let it finish.
        await tester.pump(Duration(seconds: 2));
      },
      () => fakeServer((request) async {
        await Future<void>.delayed(Duration(seconds: 2));
        return jsonResponse(meAnswer());
      }),
    );

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('a 401 at startup deletes the token: login', (tester) async {
    FlutterSecureStorage.setMockInitialValues({"user_token": "1|revoked"});

    await http.runWithClient(
      () => pumpApp(tester),
      () => fakeServer(
        (request) async =>
            jsonResponse({"message": "Unauthenticated."}, status: 401),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(await storage.read(key: "user_token"), isNull);
  });

  testWidgets('logging in opens the profile and saves the token', (
    tester,
  ) async {
    await http.runWithClient(
      () async {
        await pumpApp(tester);
        await tester.enterText(fieldWithHint("Email"), "sara@example.com");
        await tester.enterText(fieldWithHint("Password"), "secret123");
        await tester.tap(find.text("Log in"));
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        if (request.url.path == "/api/auth/login") {
          return jsonResponse(loginAnswer());
        }
        return jsonResponse(meAnswer());
      }),
    );

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(await storage.read(key: "user_token"), "1|fake-token");
  });

  testWidgets('logout deletes the token and returns to login', (tester) async {
    FlutterSecureStorage.setMockInitialValues({"user_token": "1|fake-token"});
    final paths = <String>[];

    await http.runWithClient(
      () async {
        await pumpApp(tester);
        await tester.tap(find.text("Log out"));
        await tester.pumpAndSettle();
        expect(find.text("Log out of Onstagram?"), findsOneWidget);

        // The dialog's own "Log out" confirms.
        await tester.tap(find.text("Log out").last);
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        paths.add(request.url.path);
        if (request.url.path == "/api/auth/logout") {
          return jsonResponse({
            "message": "Logged out successfully",
            "data": null,
          });
        }
        return jsonResponse(meAnswer());
      }),
    );

    expect(paths, contains("/api/auth/logout"));
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text("Logged out successfully"), findsOneWidget);
    expect(await storage.read(key: "user_token"), isNull);
  });
}
