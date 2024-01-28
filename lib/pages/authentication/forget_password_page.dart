import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/containers/option_container.dart';
import '../../widgets/icons/circular_svg_icon.dart';
import '../../widgets/padding/base_padding.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  OptionContainer _buildOptionContainer(BuildContext context, bool select,
          String assetName, String text1, String text2) =>
      OptionContainer(
        height: context.responsiveHeight(80),
        context: context,
        select: true,
        border: Border.all(
          width: 1,
          color: AppThemes.lightTheme.colorScheme.primary,
        ),
        child: Row(
          children: [
            CircularSvgIcon(
              context: context,
              assetName: assetName,
            ),
            SizedBox(width: context.responsiveWidth(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text1, style: context.textStyle.subheadSmallMedium),
                FittedBox(
                  child: Text(
                    text2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: HexColor('#5A5A5A'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            Text(
              'Forgot Password',
              style: context.textStyle.titleMedMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(12),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveWidth(25),
              ),
              child: Text(
                'Select which contact details should we use to reset your password',
                textAlign: TextAlign.center,
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor('#D0D0D0'),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(36),
            ),
            _buildOptionContainer(
                context, true, 'assets/svg/sms.svg', 'Via SMS', '***** ***70'),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            PrimaryButton(
              text: 'Continue',
              context: context,
              onPressed: () {
                NavigationManager.instance
                    .navigationToPage(NavigationConstant.sendVerification);
              },
            ),
          ],
        ),
      ),
    );
  }
}
