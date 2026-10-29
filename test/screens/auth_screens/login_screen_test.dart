import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/main.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/fake_server.dart';

Finder fieldWithHint(String hint) => find.widgetWithText(TextFormField, hint);

void main() {
  testWidgets('an empty form shows what is missing and sends nothing', (
    tester,
  ) async {
    var requests = 0;

    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MyApp());
        await tester.tap(find.text("Log in"));
        await tester.pump();
      },
      () => fakeServer((request) async {
        requests++;
        return jsonResponse(loginAnswer());
      }),
    );

    expect(find.text("Enter your email"), findsOneWidget);
    expect(find.text("Enter your password"), findsOneWidget);
    expect(requests, 0);
  });

  testWidgets('a broken email is refused by EmailsValidator', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(fieldWithHint("Email"), "sara@");
    await tester.tap(find.text("Log in"));
    await tester.pump();

    expect(find.text("Enter a valid email"), findsOneWidget);
  });

  testWidgets('the eye shows and hides the password', (tester) async {
    await tester.pumpWidget(const MyApp());
    bool isHidden() => tester
        .widget<EditableText>(
          find.descendant(
            of: fieldWithHint("Password"),
            matching: find.byType(EditableText),
          ),
        )
        .obscureText;

    expect(isHidden(), isTrue);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(isHidden(), isFalse);
  });

  testWidgets('a valid form posts to /api/auth/login', (tester) async {
    http.Request? sent;

    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MyApp());
        await tester.enterText(fieldWithHint("Email"), "sara@example.com");
        await tester.enterText(fieldWithHint("Password"), "secret123");
        await tester.tap(find.text("Log in"));
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        sent = request;
        return jsonResponse(loginAnswer());
      }),
    );

    expect(sent!.url.path, "/api/auth/login");
    expect(sent!.bodyFields, {
      "email": "sara@example.com",
      "password": "secret123",
    });
  });

  Future<void> fillAndSubmit(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(fieldWithHint("Email"), "sara@example.com");
    await tester.enterText(fieldWithHint("Password"), "secret123");
    await tester.tap(find.text("Log in"));
  }

  Color? snackBarColor(WidgetTester tester) {
    return tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor;
  }

  testWidgets('a good login shows a green SnackBar', (tester) async {
    await http.runWithClient(() async {
      await fillAndSubmit(tester);
      await tester.pumpAndSettle();
    }, () => fakeServer((request) async => jsonResponse(loginAnswer())));

    expect(find.text("Login successful"), findsOneWidget);
    expect(snackBarColor(tester), const Color(0xff58C322));
  });

  testWidgets('a refused login shows the server sentence in red', (
    tester,
  ) async {
    await http.runWithClient(
      () async {
        await fillAndSubmit(tester);
        await tester.pumpAndSettle();
      },
      () => fakeServer(
        (request) async => jsonResponse(wrongPasswordAnswer(), status: 422),
      ),
    );

    expect(
      find.text("The provided credentials are incorrect."),
      findsOneWidget,
    );
    expect(snackBarColor(tester), const Color(0xffED4956));
  });

  testWidgets('while waiting: a spinner, and more taps send nothing', (
    tester,
  ) async {
    var requests = 0;

    await http.runWithClient(
      () async {
        await fillAndSubmit(tester);
        await tester.pump();

        expect(find.text("Log in"), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.tap(find.byType(CircularProgressIndicator));

        await tester.pump(Duration(seconds: 1));
        await tester.pumpAndSettle();
      },
      () => fakeServer((request) async {
        requests++;
        await Future<void>.delayed(Duration(seconds: 1));
        return jsonResponse(loginAnswer());
      }),
    );

    expect(requests, 1);
    expect(find.text("Log in"), findsOneWidget);
  });
}
