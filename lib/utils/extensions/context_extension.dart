import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get height => mediaQueryData.size.height;

  double get width => mediaQueryData.size.width;

  double responsiveHeight(double value) => (value * height) / 867.4285714285714;

  double responsiveWidth(double value) => (value * width) / 411.4285714285714;
}
