import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/models/user/user_identity_model.dart';
import 'package:shazy/services/user/user_identity_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../widgets/app_bars/back_app_bar.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/padding/base_padding.dart';
import '../../../widgets/textfields/name_text_from_field.dart';

class DriverLicance extends StatelessWidget {
  DriverLicance({super.key});

  TextEditingController _drivingLicanceController = TextEditingController();
  TextEditingController _criminalRecordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'makeAnApplication'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'driverVerification'.tr(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: HexColor("#494949"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(40),
            ),
            Text(
              'barcodeNoVehicle'.tr(),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: HexColor("#494949"),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(11),
            ),
            Text(
              'barcodeNoVehicleDesc'.tr(),
              style: context.textStyle.bodySmallMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            NameTextFormField(
              context: context,
              controller: _drivingLicanceController,
              hintText: 'barcodeNo'.tr(),
            ),
            SizedBox(
              height: context.responsiveHeight(40),
            ),
            Text(
              'barcodeNoCriminalRecord'.tr(),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: HexColor("#494949"),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(11),
            ),
            Text(
              'barcodeNoCriminalRecordDesc'.tr(),
              style: context.textStyle.bodySmallMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            NameTextFormField(
              context: context,
              controller: _criminalRecordController,
              hintText: 'barcodeNo'.tr(),
            ),
            SizedBox(
              height: context.responsiveHeight(200),
            ),
            PrimaryButton(
              context: context,
              text: 'makeAnApplication'.tr(),
              onPressed: () async {
                if (_criminalRecordController.text == '' ||
                    _drivingLicanceController.text == '') {
                  HelperFunctions.instance.showErrorDialog(
                      context, 'emptyTextError'.tr(), 'cancel'.tr(), () {
                    NavigationManager.instance.navigationToPop();
                  });
                } else {
                  await UserIdentityService.instance
                      .putUserIdentity(UserIdentityModel(
                    drivingLicance: _drivingLicanceController.text,
                    criminalRecord: _criminalRecordController.text,
                  ));
                  NavigationManager.instance.navigationToPageClear(
                      NavigationConstant.driverCompleteSecond);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
