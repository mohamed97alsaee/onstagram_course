import 'package:flutter_test/flutter_test.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';

void main() {
  test('starts light', () {
    expect(DarkModeProvider().isDark, isFalse);
  });

  test('switchMode flips isDark and tells the listeners once', () {
    final darkModeProvider = DarkModeProvider();
    var calls = 0;
    darkModeProvider.addListener(() => calls++);

    darkModeProvider.switchMode();
    expect(darkModeProvider.isDark, isTrue);
    expect(calls, 1);

    darkModeProvider.switchMode();
    expect(darkModeProvider.isDark, isFalse);
    expect(calls, 2);
  });
}
