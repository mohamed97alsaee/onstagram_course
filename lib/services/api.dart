import 'package:http/http.dart' as http;
import 'package:onstagram/helpers/consts.dart';

class Api {
  // One place for the headers: every request sends the same ones.
  Map<String, String> _headers() {
    return {"Accept": "application/json", "X-Student-Api-Key": studentApiKey};
  }

  Future<http.Response> get(String endPoint) {
    return http.get(Uri.parse(baseUrl + endPoint), headers: _headers());
  }

  Future<http.Response> post(String endPoint, Map body) {
    return http.post(
      Uri.parse(baseUrl + endPoint),
      body: body,
      headers: _headers(),
    );
  }
}
