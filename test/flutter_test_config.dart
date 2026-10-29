import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

// Runs before every test file.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Tests never download fonts: Cairo is bundled in google_fonts/.
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
