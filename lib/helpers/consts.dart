import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

// ------------------ API CONSTANTS ------------------

// Read from .env.json at build time (--dart-define-from-file).
// Never write the key here: this file goes to GitHub.
const String studentApiKey = String.fromEnvironment("STUDENT_API_KEY");

// ------------------ COLORS CONSTANTS ------------------

Color blueColor = Color(0xff0095F6);
Color whiteColor = Color(0xffffffff);
Color blackColor = Color(0xff000000);
Color greenColor = Color(0xff58C322);
Color redColor = Color(0xffED4956);

Color textColor = Color(0xff262626);
Color greyTextColor = Color(0xff8E8E8E);
Color hintColor = Color(0xffC7C7C7);
Color borderColor = Color(0xffDBDBDB);
Color fieldColor = Color(0xffFAFAFA);
Color buttonColor = Color(0xffEFEFEF);

// ------------------ TEXT STYLES CONSTANTS ------------------

TextStyle titleLarge = GoogleFonts.cairo(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle titleMedium = GoogleFonts.cairo(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle labelLarge = GoogleFonts.cairo(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

TextStyle bodyLarge = GoogleFonts.cairo(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

TextStyle bodyMedium = GoogleFonts.cairo(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

TextStyle bodySmall = GoogleFonts.cairo(
  fontSize: 12,
  fontWeight: FontWeight.normal,
);

// ------------------ THEMES CONSTANTS ------------------

ThemeData theme = ThemeData(
  colorScheme: .fromSeed(
    seedColor: blueColor,
    primary: blueColor,
    surface: whiteColor,
    onSurface: textColor,
    error: redColor,
  ),
  scaffoldBackgroundColor: whiteColor,
  appBarTheme: AppBarThemeData(
    backgroundColor: whiteColor,
    scrolledUnderElevation: 0,
    titleTextStyle: titleLarge.copyWith(color: textColor),
  ),
  dividerTheme: DividerThemeData(color: borderColor, thickness: 1, space: 1),
  textTheme: TextTheme(
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    labelLarge: labelLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  ),
  inputDecorationTheme: InputDecorationThemeData(
    isDense: true,
    filled: true,
    fillColor: fieldColor,
    hintStyle: bodyLarge.copyWith(color: hintColor),
    errorStyle: bodySmall.copyWith(color: redColor),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
    // Focus only darkens the grey line, like Instagram.
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: greyTextColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: redColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: redColor),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: whiteColor,
    barrierColor: blackColor.withValues(alpha: 0.5),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
