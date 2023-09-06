import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color primary = Color(0xff5f95cc);
  static const Color secondary = Color(0xffce5252);

  static const Color red = Color(0xffCE5252);
  static const Color blue = Color(0xff5F95CC);
  static const Color green = Color(0xff53A342);
  static const Color yellow = Color(0xffCC965F);
  static const Color purple = Color(0xffCC5FCC);
  static const Color darkBlue = Color(0xff3C7BBC);

  static const Color dark900 = Color(0xff111111);
  static const Color dark700 = Color(0xff1c1c1e);
  static const Color dark600 = Color(0xff28282a);
  static const Color dark500 = Color(0xff3d3d3d);
  static const Color dark400 = Color(0xff686868);
  static const Color dark300 = Color(0xff989898);
}

class AppThemes {
  static final darkTheme = ThemeData(
    textTheme:
        getTextTheme(textColor: Colors.yellow, buttonColor: Colors.white),
    fontFamily: "Poppins",

    /*scaffoldBackgroundColor: ProgramColors.gloneraDarkBackground,
    fontFamily: "Poppins",
    primaryColor: ProgramColors.gloneraDarkMainGray,
    colorScheme: ColorScheme.dark(
        primary: ProgramColors.gloneraDarkMainGray,
        secondary: Colors.white70,
        onBackground: ProgramColors.gloneraDarkMainGray),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all<Color>(ProgramColors.gloneraDarkMainGray),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
      ),
    ),
    textButtonTheme:
    TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white)),
    textTheme: getTextTheme(textColor: Colors.white, buttonColor: Colors.white),
    toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: Color(0xFF747474),
        color: ProgramColors.gloneraDarkMainGray,
        disabledColor: Colors.white),
    snackBarTheme:
    SnackBarThemeData(backgroundColor: ProgramColors.gloneraDarkMainGray),*/
  );

  static final lightTheme = ThemeData(
    textTheme: getTextTheme(
      textColor: Colors.white,
      buttonColor: Colors.white,
    ),
    fontFamily: "Poppins",
    useMaterial3: true,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onBackground: AppColors.white,
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
    ),
  );

  static TextTheme getTextTheme(
      {required Color textColor, required Color buttonColor}) {
    return TextTheme(
      titleLarge: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 24),
      titleMedium: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 16),
      displayLarge: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 24),
      displayMedium: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 18),
      headlineLarge: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 14),
      headlineMedium: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 14),
      headlineSmall: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 12),
      bodyLarge: TextStyle(
          color: buttonColor, fontWeight: FontWeight.w500, fontSize: 16),
      bodyMedium: TextStyle(
          color: buttonColor, fontWeight: FontWeight.w500, fontSize: 14),
      bodySmall: TextStyle(
          color: buttonColor, fontWeight: FontWeight.w500, fontSize: 12),
    );
  }
}
