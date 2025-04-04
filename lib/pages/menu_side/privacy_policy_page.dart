import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'privacyPolicy'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'privacyPolicyForRideShare'.tr(),
              style: context.textStyle.headlineLargeMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Text(
              "At Rideshare, accessible from rideshare.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by rideshare and how we use it.\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.\nThis Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in rideshare. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the Free Privacy Policy Generator.",
              style: context.textStyle.subheadLargeRegular,
            ),
          ],
        ),
      ),
    );
  }
}
