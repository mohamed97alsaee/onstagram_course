import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/screens/auth_screens/register_screen.dart';
import 'package:onstagram/screens/main_screens/tabs_content/profile_screen.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/fake_server.dart';
import '../../helpers/test_app.dart';

Future<void> openRegisterScreen(WidgetTester tester) async {
  await pumpApp(tester);
  await tester.tap(find.text("Sign up"));
  await tester.pumpAndSettle();
  expect(find.byType(RegisterScreen), findsOneWidget);
}

Future<void> fillForm(WidgetTester tester) async {
  await tester.enterText(fieldWithHint("Full name"), "Sara Ahmed");
  await tester.enterText(fieldWithHint("Username"), "sara_ahmed");
  await tester.enterText(fieldWithHint("Email"), "sara@example.com");
  await tester.enterText(fieldWithHint("Password"), "secret123");
}

void main() {
  testWidgets('a taken username says so after a short pause', (tester) async {
    final paths = <String>[];

    await http.runWithClient(
      () async {
        await openRegisterScreen(tester);
        await tester.enterText(fieldWithHint("Username"), "sara");
        await tester.pump(Duration(milliseconds: 400));
        expect(find.text("Username is already taken."), findsNothing);

        await tester.pump(Duration(milliseconds: 100));
        await tester.pump();
        expect(find.text("Username is already taken."), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // A taken name can't sign up: the tap sends nothing.
        await tester.enterText(fieldWithHint("Full name"), "Sara Ahmed");
        await tester.enterText(fieldWithHint("Email"), "sara@example.com");
        await tester.enterText(fieldWithHint("Password"), "secret123");
        await tester.tap(find.text("Sign up").first);
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        paths.add(request.url.path);
        return jsonResponse(usernameAnswer("sara", false));
      }),
    );

    expect(paths, isNot(contains("/api/auth/register")));
    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('fast typing sends one request, not one per key', (tester) async {
    var checks = 0;

    await http.runWithClient(
      () async {
        await openRegisterScreen(tester);
        for (final text in ["sar", "sara", "sara_", "sara_ahmed"]) {
          await tester.enterText(fieldWithHint("Username"), text);
          await tester.pump(Duration(milliseconds: 100));
        }
        await tester.pump(Duration(milliseconds: 500));
        await tester.pump();
      },
      () => fakeServer((request) async {
        checks++;
        return jsonResponse(usernameAnswer("sara_ahmed", true));
      }),
    );

    expect(checks, 1);
    expect(find.text("Username is available."), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('signing up signs in and opens the profile', (tester) async {
    http.Request? registerRequest;

    await http.runWithClient(
      () async {
        await openRegisterScreen(tester);
        await fillForm(tester);
        await tester.pump(Duration(milliseconds: 500));
        await tester.tap(find.text("Sign up").first);
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        switch (request.url.path) {
          case "/api/auth/register":
            registerRequest = request;
            return jsonResponse(loginAnswer(), status: 201);
          case "/api/auth/me":
            return jsonResponse(meAnswer());
          default:
            return jsonResponse(usernameAnswer("sara_ahmed", true));
        }
      }),
    );

    expect(registerRequest!.bodyFields, {
      "name": "Sara Ahmed",
      "username": "sara_ahmed",
      "email": "sara@example.com",
      "password": "secret123",
    });
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(await storage.read(key: "user_token"), "1|fake-token");
  });

  testWidgets('a refused sign up stays here and says why in red', (
    tester,
  ) async {
    await http.runWithClient(
      () async {
        await openRegisterScreen(tester);
        await fillForm(tester);
        await tester.pump(Duration(milliseconds: 500));
        await tester.tap(find.text("Sign up").first);
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        if (request.url.path == "/api/auth/register") {
          return jsonResponse({
            "message": "The email has already been taken.",
            "errors": {
              "email": ["The email has already been taken."],
            },
          }, status: 422);
        }
        return jsonResponse(usernameAnswer("sara_ahmed", true));
      }),
    );

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text("The email has already been taken."), findsOneWidget);
  });

  testWidgets('"Log in" goes back to the login screen', (tester) async {
    await openRegisterScreen(tester);

    await tester.tap(find.text("Log in"));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsNothing);
  });
}
