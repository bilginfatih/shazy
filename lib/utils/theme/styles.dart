import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../extensions/context_extension.dart';

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

  TextStyle get titleLargeMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(28),
        fontWeight: FontWeight.w500,
      );

  TextStyle get titleMedRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 24,
        fontWeight: FontWeight.w400,
      );

  TextStyle get titleSmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 22,
        fontWeight: FontWeight.w400,
      );

  TextStyle get titleSmallMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(22),
        fontWeight: FontWeight.w500,
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

  TextStyle get headlineLargeMedium => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _context.isLight ? HexColor('#2A2A2A') : null,
      );

  TextStyle get headlineSmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 18,
        fontWeight: FontWeight.w400,
      );

  TextStyle get headlineSmallMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(18),
        fontWeight: FontWeight.w500,
      );

  TextStyle get headlineSmallBold => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(18),
        fontWeight: FontWeight.w700,
      );

  TextStyle get subheadLargeRegular => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(16),
        fontWeight: FontWeight.w400,
      );

  TextStyle get subheadLargeMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(16),
        fontWeight: FontWeight.w500,
      );

  TextStyle get subheadLargeSemibold => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get subheadSmallRegular => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(14),
        fontWeight: FontWeight.w500,
      );

  TextStyle get subheadSmallMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(14),
        fontWeight: FontWeight.w500,
        color: HexColor('#B8B8B8'),
      );

  TextStyle get bodyLargeRegular => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(16),
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodyLargeMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(16),
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(14),
        fontWeight: FontWeight.w500,
        color: HexColor('#5A5A5A'),
      );

  TextStyle get bodyMediumRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 14,
        fontWeight: FontWeight.w400,
        color: HexColor('#5A5A5A'),
      );

  TextStyle get bodySmallMedium => GoogleFonts.poppins(
        fontSize: _context.responsiveFont(12),
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodySmallRegular => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get labelSmallMedium => GoogleFonts.poppins(
        fontSize: _context.mediaQueryData.textScaleFactor * 12,
        fontWeight: FontWeight.w500,
        color: HexColor('#5A5A5A'),
      );
}
