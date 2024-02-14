import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/padding/base_padding.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            SizedBox(
              height: context.responsiveHeight(270),
            ),
            Text(
              'Welcome'.tr(),
              style: context.textStyle.titleMedMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(12),
            ),
            Text(
              'WelcomePageDescription'.tr(),
              style: context.textStyle.bodyLargeRegular.copyWith(
                color: HexColor("#D0D0D0"),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              context: context,
              text: 'CreateAccount'.tr(),
              onPressed: () {
                NavigationManager.instance
                    .navigationToPage(NavigationConstant.signUp);
              },
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            SecondaryButton(
              context: context,
              text: 'LogIn'.tr(),
              onPressed: () {
                NavigationManager.instance
                    .navigationToPage(NavigationConstant.signIn);
              },
            )
          ],
        ),
      ),
    );
  }
}
