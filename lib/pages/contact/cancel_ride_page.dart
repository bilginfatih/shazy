import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';

import '../../core/init/navigation/navigation_manager.dart';

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

  Future<dynamic> _submitOnPressed(BuildContext context) => showDialog(
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

  BasePadding _buildDialogWidget(BuildContext context) => BasePadding(
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
                text: 'Back Home', context: context, onPressed: () {}),
          ],
        ),
      );

  Padding _buildContainer(BuildContext context, String text, bool isSelect) =>
      Padding(
        padding: EdgeInsets.only(
          bottom: context.responsiveHeight(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelect ? AppThemes.lightPrimary500 : HexColor('#D0D0D0'),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: context.responsiveHeight(20.0),
                bottom: context.responsiveHeight(20.0),
                left: context.responsiveWidth(10)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_values[text] == null) {
                        _values[text] = true;
                      } else {
                        _values[text] = !_values[text]!;
                      }
                    });
                  },
                  child: Container(
                    width: context.responsiveWidth(24),
                    height: context.responsiveHeight(24),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelect ? HexColor('#43A048') : null),
                    child: isSelect
                        ? const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.white,
                          )
                        : const SizedBox(),
                  ),
                ),
                SizedBox(
                  width: context.responsiveWidth(14),
                ),
                Text(
                  text,
                  style: context.textStyle.bodyLargeMedium
                      .copyWith(color: HexColor('#5A5A5A')),
                ),
              ],
            ),
          ),
        ),
      );

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
            for (var item in _values.keys)
              _buildContainer(context, item, _values[item] ?? false),
            Container(
              constraints:
                  BoxConstraints(maxHeight: context.responsiveHeight(118)),
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
                onPressed: () {
                  _submitOnPressed(context);
                }),
          ],
        ),
      ),
    );
  }
}
