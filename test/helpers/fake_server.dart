import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake API: [handler] answers every request, nothing leaves the test.
MockClient fakeServer(
  Future<http.Response> Function(http.Request request) handler,
) {
  return MockClient(handler);
}

/// A JSON answer, shaped like the real server's.
http.Response jsonResponse(Object body, {int status = 200}) {
  return http.Response(
    json.encode(body),
    status,
    headers: {"content-type": "application/json; charset=utf-8"},
  );
}
