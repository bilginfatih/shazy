import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppThemes {
  static Color lightPrimary500 = HexColor('#9C54D5');
  static Color lightPrimary50 = HexColor('#F5EEFB');
  Color lightSecondary400 = HexColor('#81C8BD');
  Color lightTertiary400 = HexColor('#FEFEE5');
  Color darkPrimaryColor = HexColor('#FFD2BB');
  static Color teriary400 = HexColor('#FEFEE5');
  static Color teriary600 = HexColor('#E7E7CB');
  static Color contentSecondary = HexColor('#414141');
  static Color hintTextNeutral = HexColor('#D0D0D0');
  static Color borderSideColor = HexColor('#B8B8B8');
  static Color secondary50 = HexColor('#eff8f7');
  static Color secondary500 = HexColor('#61BAAD');
  static Color secondary700 = HexColor('#45847B');
  static Color primary100 = HexColor('#E0CAF2');
  static Color success700 = HexColor('#388E3D');
  static Color error700 = HexColor('#D32F2F');
  static Color darkBg = HexColor('#1F212A');
  static Color warningYellow700 = HexColor('#FBC02D');

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppThemes.lightPrimary500,
      secondary: _appThemes.lightSecondary400,
      tertiary: _appThemes.lightTertiary400,
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )))),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      background: HexColor('#2A2A2A'),
      primary: _appThemes.darkPrimaryColor,
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )))),
  );
}

AppThemes _appThemes = AppThemes();
