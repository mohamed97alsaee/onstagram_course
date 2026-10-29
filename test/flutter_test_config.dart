import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

// Runs before every test file.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Tests never download fonts: Cairo is bundled in google_fonts/.
  GoogleFonts.config.allowRuntimeFetching = false;
  // Every test starts with an empty secure storage (no saved token).
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  await testMain();
}
