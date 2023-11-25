import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class TwoSelectContainer extends Container {
  TwoSelectContainer({
    Key? key,
    required BuildContext context,
    required String text1,
    required String text2,
    required VoidCallback onTap1,
    required VoidCallback onTap2,
    required bool isSelectedDriver,
  }) : super(
          key: key,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: AppThemes.lightPrimary500,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTap1,
                child: Container(
                  width: context.responsiveWidth(178),
                  height: context.responsiveHeight(40),
                  decoration: _selectedDecoration(isSelectedDriver),
                  child: Center(
                    child: Text(
                      text1,
                      style: _selectedTextStyle(isSelectedDriver),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTap2,
                child: Container(
                  width: context.responsiveWidth(179),
                  height: context.responsiveHeight(40),
                  decoration: _selectedDecoration(!isSelectedDriver),
                  child: Center(
                    child: Text(
                      text2,
                      style: _selectedTextStyle(!isSelectedDriver),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

  static TextStyle _selectedTextStyle(bool isSelected) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: isSelected ? Colors.white : AppThemes.lightPrimary500,
    );
  }

  static BoxDecoration _selectedDecoration(bool isSelected) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: isSelected ? AppThemes.lightPrimary500 : null,
    );
  }
}
