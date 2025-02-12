// import 'package:flutter/material.dart';

// ThemeData light = ThemeData(
//   fontFamily: 'TitilliumWeb',
//   primaryColor: const Color(0xFF1455AC),
//   bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
//   brightness: Brightness.light,
//   highlightColor: Colors.white,
//   hintColor: const Color(0xFF9E9E9E),
//   disabledColor:  const Color(0xFF343A40),
//   canvasColor: const Color(0xFFFCFCFC),
//   cardColor: const Color(0xFFFFFFFF),
//   splashColor: Colors.transparent,
//   colorScheme: const ColorScheme.light(

//     error: Color(0xFFFF5A5A),
//     primary: Color(0xFF1455AC),
//     secondary: Color(0xFF004C8E),
//     tertiary: Color(0xFFF9D4A8),
//     tertiaryContainer: Color(0xFFADC9F3),
//     onTertiaryContainer: Color(0xFF33AF74),
//     primaryContainer: Color(0xFF9AECC6),
//     secondaryContainer: Color(0xFFF2F2F2),
//     surface: Color(0xFFFFFFFF),
//     surfaceTint: Color(0xFF0087FF),
//     onPrimary: Color(0xFF67AFFF),
//     onSecondary: Color(0xFFFC9926),
//   ),

//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.android: ZoomPageTransitionsBuilder(),
//     TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
//     TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
//   }),
// );
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: const Color(0xFF3CB67D), // Updated primary color
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFFADADAD), // Updated hint color to match secondary
  disabledColor:
      const Color(0xFFADADAD), // Updated disabled color to match secondary
  canvasColor: const Color(0xFFFFFFFF), // Background color
  cardColor: const Color(0xFFFFFFFF), // Card color
  splashColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
    error: Color(0xFFFF5A5A), // Keep error color as is
    primary: Color(0xFF3CB67D), // Updated primary color
    secondary: Color(0xFFDDF9EB), // Updated secondary color
    tertiary: Color(0xFF9AECC6), // Optional: update if needed
    tertiaryContainer: Color(0xFFADC9F3), // Optional: update if needed
    onTertiaryContainer: Color(0xFF33AF74), // Optional: update if needed
    primaryContainer: Color(0xFF9AECC6), // Optional: update if needed
    secondaryContainer: Color(0xFFADADAD), // Updated secondary container color
    surface: Color(0xFFFFFFFF), // Surface color
    surfaceTint: Color(0xFF3CB67D), // Updated surface tint to match primary
    onPrimary: Color(0xFF263C51), // Updated to text color
    onSecondary: Color(0xFF263C51), // Updated to text color
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
