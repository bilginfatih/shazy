import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../models/cancel_reason/cancel_reason_model.dart';
import '../../services/cancel_reason/cancel_reason_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../home/home_screen_transport.dart';

class CancelRidePage extends StatefulWidget {
  const CancelRidePage({super.key});

  @override
  State<CancelRidePage> createState() => _CancelRidePageState();
}

class _CancelRidePageState extends State<CancelRidePage> {
  final Map<String, bool> _values = {};

  @override
  void initState() {
    _values['Waiting for long time'] = false;
    _values['Unable to contact driver'] = false;
    _values['Driver denied to go to destination'] = false;
    _values['Driver denied to come to pickup'] = false;
    _values['Wrong address shown'] = false;
    _values['The price is not reasonable'] = false;
    super.initState();
  }

  Future<dynamic> _submitOnPressed(BuildContext context) async {
    String? isDriver = ModalRoute.of(context)?.settings.arguments as String?;
    List<String> selectedReasons = [];
    _values.forEach((key, value) {
      if (value) {
        selectedReasons.add(key);
      }
    });
    String reasonsString = selectedReasons.join(', '); // Seçilen nedenleri bir stringe dönüştürme
    print('Selected reasons: $reasonsString');
    String userId = await SessionManager().get('id');
    print('isDriver: ' + isDriver.toString());
    if (isDriver == 'driverId') {
      CancelReasonModel model = CancelReasonModel(driverId: userId, status: 'accept', reason: reasonsString);
      await CancelReasonService.instance.cancelReason(model);
    } else {
      CancelReasonModel model = CancelReasonModel(callerId: userId, status: 'accept', reason: reasonsString);
      await CancelReasonService.instance.cancelReason(model);
    }

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          vertical: context.responsiveHeight(230),
          horizontal: context.responsiveWidth(16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _buildDialogWidget(context),
      ),
    );
  }

  BasePadding _buildDialogWidget(BuildContext context) {
    String? isDriver = ModalRoute.of(context)?.settings.arguments as String?;
    return BasePadding(
      context: context,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Material(
              child: GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: SvgPicture.asset(
                    'assets/svg/cancel.svg',
                    width: context.responsiveWidth(24),
                    height: context.responsiveHeight(24),
                  ),
                ),
                onTap: () {
                  NavigationManager.instance.navigationToPop();
                },
              ),
            ),
          ),
          SizedBox(
            height: context.responsiveHeight(27),
          ),
          Text(
            'We\'re so sad about your cancellation',
            style: context.textStyle.titleSmallMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.responsiveHeight(10),
          ),
          Text(
            'We will continue to improve our service & satify you on the next trip.',
            style: context.textStyle.bodySmallMedium.copyWith(
              color: HexColor('#898989'),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.responsiveHeight(41),
          ),
          PrimaryButton(
              text: 'Back Home',
              context: context,
              onPressed: () {
                HomeScreenTransport.allowNavigation = true;
                if (isDriver == 'driverId') {
                  NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
                } else {
                  NavigationManager.instance.navigationToPop();
                  NavigationManager.instance.navigationToPop();
                }
              }),
        ],
      ),
    );
  }

  Padding _buildContainer(BuildContext context, String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.responsiveHeight(15)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // Seçili nedeni güncelle
            _values.forEach((key, value) {
              _values[key] = key == text;
            });
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppThemes.lightPrimary500 : HexColor('#D0D0D0'),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsiveHeight(20)),
            child: Row(
              children: [
                Container(
                  width: context.responsiveWidth(24),
                  height: context.responsiveHeight(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? HexColor('#43A048') : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                      : SizedBox(),
                ),
                SizedBox(width: context.responsiveWidth(14)),
                Text(
                  text,
                  style: context.textStyle.bodyLargeMedium.copyWith(color: HexColor('#5A5A5A')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Cancel Driver',
      ),
      body: BasePadding(
        context: context,
        child: ListView(
          children: [
            Text(
              'Please select the reason of cancellation.',
              style: context.textStyle.subheadSmallMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            for (var item in _values.keys) _buildContainer(context, item, _values[item] ?? false),
            Container(
              constraints: BoxConstraints(maxHeight: context.responsiveHeight(118)),
              child: TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Other',
                  hintStyle: context.textStyle.subheadLargeMedium.copyWith(
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
            ),
            SizedBox(
              height: context.responsiveHeight(25),
            ),
            PrimaryButton(
                text: 'Submit',
                context: context,
                onPressed: () async {
                  _submitOnPressed(context);
                }),
          ],
        ),
      ),
    );
  }
}
