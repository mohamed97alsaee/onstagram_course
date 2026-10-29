import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:onstagram/providers/auth_provider.dart';

import '../helpers/fake_data.dart';
import '../helpers/fake_server.dart';

void main() {
  group('login', () {
    test('posts the form to /api/auth/login and keeps the token', () async {
      late http.Request sent;
      final authProvider = AuthProvider();

      final message = await http.runWithClient(
        () => authProvider.login({
          "email": "sara@example.com",
          "password": "secret123",
        }),
        () => fakeServer((request) async {
          sent = request;
          return jsonResponse(loginAnswer());
        }),
      );

      expect(sent.method, "POST");
      expect(sent.url.path, "/api/auth/login");
      expect(sent.bodyFields["email"], "sara@example.com");
      expect(message, "Login successful");
      expect(authProvider.token, "1|fake-token");
    });

    test('a 422 returns the server sentence and no token', () async {
      final authProvider = AuthProvider();

      final message = await http.runWithClient(
        () => authProvider.login({
          "email": "sara@example.com",
          "password": "wrong",
        }),
        () => fakeServer(
          (request) async => jsonResponse(wrongPasswordAnswer(), status: 422),
        ),
      );

      expect(message, "The provided credentials are incorrect.");
      expect(authProvider.token, isNull);
    });
  });
}
