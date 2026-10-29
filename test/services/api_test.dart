import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onstagram/services/api.dart';

void main() {
  test('get sends the same headers to baseUrl + endPoint', () async {
    late http.Request sent;

    await http.runWithClient(
      () => Api().get("/api/test"),
      () => MockClient((request) async {
        sent = request;
        return http.Response('{"message": "API is working!"}', 200);
      }),
    );

    expect(sent.method, "GET");
    expect(sent.url.toString(), "https://onstagramcourse.com/api/test");
    expect(sent.headers["Accept"], "application/json");
    expect(sent.headers.containsKey("X-Student-Api-Key"), isTrue);
  });

  test('post sends the body and the same headers', () async {
    late http.Request sent;

    await http.runWithClient(
      () => Api().post("/api/auth/login", {
        "email": "sara@example.com",
        "password": "secret123",
      }),
      () => MockClient((request) async {
        sent = request;
        return http.Response('{"message": "ok"}', 200);
      }),
    );

    expect(sent.method, "POST");
    expect(sent.url.path, "/api/auth/login");
    expect(sent.bodyFields, {
      "email": "sara@example.com",
      "password": "secret123",
    });
    expect(sent.headers["Accept"], "application/json");
    expect(sent.headers.containsKey("X-Student-Api-Key"), isTrue);
  });

  group('a failed request still answers with a "message"', () {
    Future<http.Response> getWith(MockClient client) {
      return http.runWithClient(() => Api().get("/api/test"), () => client);
    }

    test('no connection: status 599 and a readable message', () async {
      final response = await getWith(
        MockClient((request) async {
          throw SocketException("Failed host lookup");
        }),
      );

      expect(response.statusCode, 599);
      expect(json.decode(response.body)['message'], "No internet connection.");
    });

    test('the client gives up: status 599', () async {
      final response = await getWith(
        MockClient((request) async {
          throw http.ClientException("Connection closed");
        }),
      );

      expect(response.statusCode, 599);
      expect(
        json.decode(response.body)['message'],
        "Could not reach the server.",
      );
    });

    test('an HTML error page keeps its status, gets a JSON body', () async {
      final response = await getWith(
        MockClient((request) async {
          return http.Response("<html>Bad Gateway</html>", 502);
        }),
      );

      expect(response.statusCode, 502);
      expect(
        json.decode(response.body)['message'],
        "The server sent an unexpected answer.",
      );
    });

    test('a JSON error (401) passes through untouched', () async {
      final response = await getWith(
        MockClient((request) async {
          return http.Response('{"message": "Unauthenticated."}', 401);
        }),
      );

      expect(response.statusCode, 401);
      expect(json.decode(response.body)['message'], "Unauthenticated.");
    });
  });
}
