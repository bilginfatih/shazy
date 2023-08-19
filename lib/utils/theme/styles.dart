import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

class AppTextStyles {
  AppTextStyles(BuildContext context) {
    _context = context;
  }

  late BuildContext _context;

  TextStyle get titleXlargeRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 34,
        fontWeight: FontWeight.w400,
      );
  TextStyle get titleLargeRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 28,
        fontWeight: FontWeight.w400,
      );
  TextStyle get titleMedRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 24,
        fontWeight: FontWeight.w400,
      );
  TextStyle get titleSmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 22,
        fontWeight: FontWeight.w400,
      );
  TextStyle get titleMedMedium => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 24,
        fontWeight: FontWeight.w500,
      );
  TextStyle get titleMedSemibold => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 24,
        fontWeight: FontWeight.w600,
      );
  TextStyle get headlineLargeRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 20,
        fontWeight: FontWeight.w400,
      );
  TextStyle get headlineSmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 18,
        fontWeight: FontWeight.w400,
      );
  TextStyle get subheadLargeRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 16,
        fontWeight: FontWeight.w400,
      );
  TextStyle get subheadLargeMedium => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subheadSmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 14,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subheadSmallMedium => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 14,
        fontWeight: FontWeight.w500,
        color: HexColor('#B8B8B8'),
      );
  TextStyle get bodyLargeRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get bodySmallMedium => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 12,
        fontWeight: FontWeight.w500,
      );
}
