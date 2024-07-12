import 'package:flutter/material.dart';

class AppTheme {
  // Define as cores principais
  static const Color primaryColor = Color(0xFF01337D);
  static const Color secondaryColor = Color(0xFF3685FF);
  static const Color accentColor = Color(0xFFFFB521);
  static const Color backgroundColor = Color(0xFFDCEAFF);
  static const Color surfaceColor = Color(0xFFEDEDED);
  static const Color blackColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);

  // Define variações de cores
  static const Color primaryColorLight = Color(0xFF4B59A6);
  static const Color primaryColorDark = Color(0xFF1A2657);
  static const Color secondaryColorLight = Color(0xFF6CA9FF);
  static const Color secondaryColorDark = Color(0xFF0041B3);

  // Define o tema principal do aplicativo
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      onPrimary: whiteColor,
      onSecondary: blackColor,
      onBackground: blackColor,
      onSurface: blackColor,
      error: Colors.red,
      onError: whiteColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: blackColor, fontSize: 32, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: blackColor, fontSize: 16),
      bodyText2: TextStyle(color: blackColor, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
          color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: secondaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: surfaceColor,
      surface: backgroundColor,
      onPrimary: whiteColor,
      onSecondary: blackColor,
      onBackground: blackColor,
      onSurface: blackColor,
      error: Colors.red,
      onError: blackColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: surfaceColor,
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: blackColor, fontSize: 32, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: blackColor, fontSize: 16),
      bodyText2: TextStyle(color: blackColor, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorDark,
      iconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
          color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: secondaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
    ),
  );
}
