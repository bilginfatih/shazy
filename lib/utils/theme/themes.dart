import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppThemes {
  Color lightPrimary500 = HexColor('#9C54D5');
  Color lightSecondary400 = HexColor('#81C8BD');
  Color lightTertiary400 = HexColor('#FEFEE5');
  Color darkPrimaryColor = HexColor('#FFD2BB');

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _appThemes.lightPrimary500,
      secondary: _appThemes.lightSecondary400,
      tertiary: _appThemes.lightTertiary400,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _appThemes.darkPrimaryColor,
    ),
  );
}

AppThemes _appThemes = AppThemes();
