import 'package:flutter/foundation.dart';

class DarkModeProvider with ChangeNotifier {
  bool isDark = false;

  void switchMode() {
    isDark = !isDark;
    // Tells every listener: "I changed, rebuild".
    notifyListeners();
  }
}
