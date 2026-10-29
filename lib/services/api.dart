import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:onstagram/helpers/consts.dart';

class Api {
  // One place for the headers: every request sends the same ones.
  Map<String, String> _headers() {
    return {"Accept": "application/json", "X-Student-Api-Key": studentApiKey};
  }

  Future<http.Response> get(String endPoint) {
    return _send("GET", endPoint, () {
      return http.get(Uri.parse(baseUrl + endPoint), headers: _headers());
    });
  }

  Future<http.Response> post(String endPoint, Map body) {
    return _send("POST", endPoint, () {
      return http.post(
        Uri.parse(baseUrl + endPoint),
        body: body,
        headers: _headers(),
      );
    });
  }

  // Every request passes here: a timeout, no crash when offline,
  // and the body is always JSON with a "message" the screen can show.
  Future<http.Response> _send(
    String method,
    String endPoint,
    Future<http.Response> Function() request,
  ) async {
    http.Response response;
    try {
      response = await request().timeout(Duration(seconds: 15));
    } on TimeoutException {
      response = _localError("The server took too long. Try again.");
    } on SocketException {
      response = _localError("No internet connection.");
    } on http.ClientException {
      response = _localError("Could not reach the server.");
    }

    if (!_isJson(response.body)) {
      response = _localError(
        "The server sent an unexpected answer.",
        response.statusCode,
      );
    }

    if (kDebugMode) {
      print("---- --- --- --- ");
      print("--- $method URL :$baseUrl$endPoint ---");
      print("--- $method STATUSCODE : ${response.statusCode}");
      print("--- $method RESPONSE : ${response.body}");
      print("---- --- --- --- ");
    }
    return response;
  }

  bool _isJson(String body) {
    try {
      json.decode(body);
      return true;
    } on FormatException {
      return false;
    }
  }

  // 599 = the request never reached the server. Our own code:
  // the API never sends it, and http refuses codes under 100.
  http.Response _localError(String message, [int statusCode = 599]) {
    return http.Response(
      json.encode({"message": message}),
      statusCode,
      headers: {"content-type": "application/json"},
    );
  }
}
