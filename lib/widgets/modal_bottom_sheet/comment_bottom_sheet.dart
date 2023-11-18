import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/padding/base_padding.dart';
import 'package:shazy/widgets/rating_bars/star_rating_bar.dart';

class CommentBottomSheet extends Padding {
  CommentBottomSheet({
    Key? key,
    String? text,
    required int selectedIndex,
    required BuildContext context,
    required VoidCallback onPressed,
    required TextEditingController textController,
  }) : super(
          key: key,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: context.customeHeight(0.5),
            child: BasePadding(
              context: context,
              child: Column(
                children: [
                  Container(
                    width: context.responsiveWidth(134),
                    height: context.responsiveHeight(5),
                    decoration: ShapeDecoration(
                      color: HexColor('#141414'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(34),
                  ),
                  StarRatingBar(selectedIndex: selectedIndex),
                  SizedBox(
                    height: context.responsiveHeight(24),
                  ),
                  Text(
                    'excellent'.tr(),
                    style: context.textStyle.headlineLargeMedium,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(8),
                  ),
                  Text(
                    text ?? '',
                    style: context.textStyle.bodySmallMedium
                        .copyWith(color: HexColor('#B8B8B8')),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(24),
                  ),
                  TextFormField(
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
