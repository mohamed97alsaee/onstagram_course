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

      final loginResult = await http.runWithClient(
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
      expect(loginResult.success, isTrue);
      expect(loginResult.message, "Login successful");
      expect(authProvider.token, "1|fake-token");
      expect(authProvider.failed, isFalse);
    });

    test('a 422 returns the server sentence and no token', () async {
      final authProvider = AuthProvider();

      final loginResult = await http.runWithClient(
        () => authProvider.login({
          "email": "sara@example.com",
          "password": "wrong",
        }),
        () => fakeServer(
          (request) async => jsonResponse(wrongPasswordAnswer(), status: 422),
        ),
      );

      expect(loginResult.success, isFalse);
      expect(loginResult.message, "The provided credentials are incorrect.");
      expect(authProvider.token, isNull);
      expect(authProvider.failed, isTrue);
    });

    test('busy is true only while the request is on its way', () async {
      final authProvider = AuthProvider();
      final busyValues = <bool>[];
      authProvider.addListener(() => busyValues.add(authProvider.busy));

      await http.runWithClient(
        () => authProvider.login({
          "email": "sara@example.com",
          "password": "secret123",
        }),
        () => fakeServer((request) async => jsonResponse(loginAnswer())),
      );

      expect(busyValues.first, isTrue);
      expect(authProvider.busy, isFalse);
    });
  });
}
