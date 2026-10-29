import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:onstagram/services/api.dart';

class AuthProvider with ChangeNotifier {
  Api api = Api();
  String? token;

  Future<String> login(Map body) async {
    final response = await api.post("/api/auth/login", body);

    if (response.statusCode == 200) {
      token = json.decode(response.body)['data']['token'];
    }
    return json.decode(response.body)['message'];
  }
}
