import 'dart:convert';

import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/models/user_profile_model.dart';
import 'package:onstagram/providers/base_provider.dart';

enum AuthStatus {
  uninitialized,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthProvider extends BaseProvider {
  AuthStatus authStatus = AuthStatus.uninitialized;
  String? token;

  UserProfileModel? currentUser;

  Future<void> initAuth() async {
    token = await storage.read(key: "user_token");

    if (token == null) {
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    authStatus = AuthStatus.authenticating;
    notifyListeners();

    // A saved token is not proof: ask the server who owns it.
    final response = await api.get("/api/auth/me");
    if (response.statusCode == 401) {
      await storage.delete(key: "user_token");
      token = null;
      authStatus = AuthStatus.unauthenticated;
    } else {
      authStatus = AuthStatus.authenticated;
      if (response.statusCode == 200) {
        currentUser = UserProfileModel.fromJson(
          json.decode(response.body)['data'],
        );
      }
    }
    notifyListeners();
  }

  Future<ActionResult> login(Map body) async {
    setBusy(true);
    final response = await api.post("/api/auth/login", body);

    if (response.statusCode == 200) {
      // Saved on the device: every request after this one sends it.
      await storage.write(
        key: "user_token",
        value: json.decode(response.body)['data']['token'],
      );
      await initAuth();
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

  Future<ActionResult> logout() async {
    setBusy(true);
    final response = await api.post("/api/auth/logout", {});

    // Offline or not, this device forgets the token.
    await storage.delete(key: "user_token");
    currentUser = null;
    await initAuth();
    setBusy(false);

    if (response.statusCode == 200) {
      return (
        success: true,
        message: json.decode(response.body)['message'] as String,
      );
    } else {
      return (success: true, message: "Logged out.");
    }
  }
}
