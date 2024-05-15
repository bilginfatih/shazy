import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../buttons/primary_button.dart';
import '../padding/base_padding.dart';
import '../rating_bars/star_rating_bar.dart';

class CommentBottomSheet extends Padding {
  CommentBottomSheet({
    Key? key,
    String? text,
    required int selectedIndex,
    required BuildContext context,
    required VoidCallback onPressed,
    required Function(int index) onPressedRatingBar,
    required TextEditingController textController,
  }) : super(
          key: key,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: context.isLight ? null : HexColor('#35383F'),
            height: context.customeHeight(0.5),
            child: BasePadding(
              context: context,
              child: Column(
                children: [
                  Container(
                    width: context.responsiveWidth(134),
                    height: context.responsiveHeight(5),
                    decoration: ShapeDecoration(
                      color: context.isLight ? HexColor('#141414') : Colors.white30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(34),
                  ),
                  StarRatingBar(
                    context: context,
                    selectedIndex: selectedIndex,
                    onTap: onPressedRatingBar,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(24),
                  ),
                  Text(
                    'excellent'.tr(),
                    style: context.textStyle.headlineLargeMedium.copyWith(
                      fontSize: context.responsiveFont(20),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(8),
                  ),
                  Text(
                    text ?? '',
                    style: context.textStyle.bodySmallMedium
                        .copyWith(color: context.isLight ? HexColor('#B8B8B8') : Colors.white30, fontSize: context.responsiveFont(12)),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(24),
                  ),
                  Container(
                    color: context.isLight ? null : HexColor('#35383F'),
                    height: context.responsiveHeight(118),
                    width: context.responsiveWidth(318),
                    child: TextFormField(
                      cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
                      controller: textController,
                      minLines: 4,
                      maxLines: 50,
                      decoration: InputDecoration(
                        hintText: 'writeYourText'.tr(),
                        hintStyle: context.textStyle.subheadSmallRegular.copyWith(
                          color: AppThemes.hintTextNeutral,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemes.borderSideColor,
                          ),
                        ),
                        focusedBorder: context.isLight
                            ? null
                            : OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppThemes.lightPrimary500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(37),
                  ),
                  PrimaryButton(
                    text: 'submit'.tr(),
                    context: context,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ),
        );
}
