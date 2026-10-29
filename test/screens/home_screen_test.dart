import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onstagram/main.dart';

void main() {
  testWidgets('Ping API shows the server message', (tester) async {
    http.Request? sent;

    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MyApp());
        await tester.tap(find.text("Ping API"));
        await tester.pumpAndSettle();
      },
      () => MockClient((request) async {
        sent = request;
        return http.Response(
          json.encode({
            "message": "API is working!",
            "data": {"timestamp": "2026-10-29T10:00:00+00:00"},
          }),
          200,
        );
      }),
    );

    expect(find.text("200: API is working!"), findsOneWidget);
    expect(sent!.method, "GET");
    expect(sent!.url.toString(), "https://onstagramcourse.com/api/test");
    expect(sent!.headers["Accept"], "application/json");
    expect(sent!.headers.containsKey("X-Student-Api-Key"), isTrue);
  });
}
