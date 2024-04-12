import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/theme/themes.dart';
import '../../../widgets/app_bars/back_app_bar.dart';
import '../../../widgets/buttons/primary_button.dart';

class DriverAccept extends StatefulWidget {
  const DriverAccept({Key? key}) : super(key: key);

  @override
  State<DriverAccept> createState() => _DriverAcceptState();
}

class _DriverAcceptState extends State<DriverAccept> {
  var _termsCheck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, mainTitle: 'Driver'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: context.responsiveWidth(46), top: context.responsiveHeight(91)),
            child: Image.asset(
              "assets/png/Driver_logo_purple1x.png",
              width: context.responsiveWidth(280),
              height: context.responsiveHeight(280),
            ),
          ),
          SizedBox(
            height: context.responsiveHeight(43),
          ),
          Padding(
            padding: EdgeInsets.only(left: context.responsiveWidth(16)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: context.responsiveHeight(13)),
                  child: CheckBoxRounded(
                    size: 16,
                    borderColor: Colors.green[600],
                    checkedWidget: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                    onTap: (bool? value) {
                      setState(() {
                        _termsCheck = value ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(width: context.responsiveWidth(10)),
                Expanded(
                  // Halile sor
                  child: RichText(
                    text: TextSpan(
                      style: context.textStyle.bodySmallMedium,
                      children: [
                        TextSpan(
                          text: '${'driverAcceptDesc'.tr()} ',
                          style: context.textStyle.bodySmallMedium.copyWith(
                            color: AppThemes.borderSideColor,
                          ),
                        ),
                        TextSpan(
                          text: '${'driversAgreement'.tr()}.',
                          style: context.textStyle.bodySmallMedium.copyWith(
                            color: AppThemes.lightPrimary500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: yapılacak
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: context.responsiveHeight(99),
          ),
          Center(
            child: PrimaryButton(
              context: context,
              text: 'makeAnApplication'.tr(),
              height: context.responsiveHeight(54),
              onPressed: () {
                if (_termsCheck) {
                  NavigationManager.instance.navigationToPage(NavigationConstant.driverChoose);
                  //NavigationManager.instance.navigationToPage(NavigationConstant.driverLicance);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
