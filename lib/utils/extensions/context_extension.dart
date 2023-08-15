import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get height => mediaQueryData.size.height;

  double get width => mediaQueryData.size.width;

  double responsiveHeight(double value) => (value * height) / 852.0;

  double responsiveWidth(double value) => (value * width) / 393.0;
}
