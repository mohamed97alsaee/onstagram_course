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
}
