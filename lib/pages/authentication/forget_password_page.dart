import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

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
            Container(
              height: context.responsiveHeight(80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: HexColor('#fffff0'),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      SvgPicture.asset('assets/svg/sms.svg'),
                      Text('data'),
                      Text('data'),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            SizedBox(
              height: context.responsiveHeight(322),
            ),
            PrimaryButton(
              text: 'Continue',
              context: context,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
