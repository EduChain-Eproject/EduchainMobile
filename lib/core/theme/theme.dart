import 'package:flutter/material.dart';

import 'app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.darkBorderColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.darkBackgroundColor,
      foregroundColor: AppPallete.darkWhiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.darkAccentColor),
      errorBorder: _border(AppPallete.darkErrorColor),
    ),
    primaryColor: AppPallete.darkPrimaryColor,
    hintColor: AppPallete.darkAccentColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple,
      accentColor: AppPallete.darkAccentColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppPallete.darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppPallete.darkWhiteColor),
      bodyMedium: TextStyle(color: AppPallete.darkGreyColor),
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.lightBackgroundColor,
      foregroundColor: AppPallete.lightPrimaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.lightAccentColor),
      errorBorder: _border(AppPallete.lightErrorColor),
    ),
    primaryColor: AppPallete.lightPrimaryColor,
    hintColor: AppPallete.lightAccentColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: AppPallete.lightAccentColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppPallete.lightAccentColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppPallete.lightPrimaryColor),
      bodyMedium: TextStyle(color: AppPallete.lightGreyColor),
    ),
  );
}
