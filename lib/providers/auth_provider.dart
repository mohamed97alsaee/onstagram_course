import 'dart:convert';

import 'package:onstagram/providers/base_provider.dart';

class AuthProvider extends BaseProvider {
  String? token;

  Future<ActionResult> login(Map body) async {
    setBusy(true);
    final response = await api.post("/api/auth/login", body);

    if (response.statusCode == 200) {
      token = json.decode(response.body)['data']['token'];
      setFailed(false);
      setBusy(false);
      return (
        success: true,
        message: json.decode(response.body)['message'] as String,
      );
    } else {
      setFailed(true);
      setBusy(false);
      return (
        success: false,
        message: json.decode(response.body)['message'] as String,
      );
    }
  }
}
