import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/containers/option_container.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class PaymetnMethodPage extends StatelessWidget {
  const PaymetnMethodPage({super.key});

  Opacity _buildPaymentMethods(
      BuildContext context, String assetName, String text1, String text2,
      {double opacity = 0.45}) {
    return Opacity(
      opacity: opacity,
      child: OptionContainer(
        context: context,
        select: true,
        height: 80,
        border: Border.all(
          width: 1,
          color: AppThemes.lightTheme.colorScheme.primary,
        ),
        color: AppThemes.lightPrimary50,
        child: Row(
          children: [
            SvgPicture.asset('assets/svg/payment/$assetName.svg'),
            SizedBox(
              width: context.responsiveWidth(13),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1,
                  style: context.textStyle.subheadLargeMedium
                      .copyWith(color: HexColor('#5A5A5A')),
                ),
                Text(text2, style: context.textStyle.subheadSmallMedium)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildPriceRow(BuildContext context, String text1, String text2) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: context.textStyle.subheadSmallRegular
                .copyWith(color: HexColor('#5A5A5A')),
          ),
          Text(
            text2,
            style: context.textStyle.subheadSmallRegular
                .copyWith(color: HexColor('#5A5A5A')),
          ),
        ],
      );

  Row _buildLocationRow(
          BuildContext context, String assetName, String text1, String text2,
          {String text3 = ''}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: context.responsiveHeight(4),
                right: context.responsiveWidth(6)),
            child: SvgPicture.asset('assets/svg/$assetName.svg'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: context.textStyle.subheadLargeMedium.copyWith(
                  color: HexColor('#5A5A5A'),
                ),
              ),
              Text(
                text2,
                style: context.textStyle.bodySmallRegular
                    .copyWith(color: HexColor('#5A5A5A')),
              ),
            ],
          ),
          const Spacer(),
          Text(
            text3,
            style: context.textStyle.bodyMedium,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Request for driver',
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationRow(
              context,
              'map2',
              'Current location',
              '4140 Parker Rd. Allentown, New...',
            ),
            SizedBox(
              height: context.responsiveHeight(29),
            ),
            _buildLocationRow(context, 'map3', 'Shop',
                '42972 Westheimer Rd. Santa Ana, Illinois 85486 ',
                text3: '2.7km'),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Text(
              'Order Summary',
              style: context.textStyle.subheadLargeMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            _buildPriceRow(context, 'Charge', '200₺'),
            SizedBox(
              height: context.responsiveHeight(9),
            ),
            _buildPriceRow(context, 'Commission', '20₺'),
            SizedBox(
              height: context.responsiveHeight(9),
            ),
            _buildPriceRow(context, 'Total Amount', '220₺'),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select payment method',
                  style: context.textStyle.headlineSmallMedium.copyWith(
                    color: HexColor('#5A5A5A'),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Add Card',
                    style: context.textStyle.subheadLargeSemibold.copyWith(
                      color: AppThemes.secondary700.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(26),
            ),
            /*Center(
              child: Text(
                'No Payment Method',
                style: context.textStyle.titleSmallMedium
                    .copyWith(color: HexColor('#898989')),
              ),
            ), */
            _buildPaymentMethods(
              context,
              'visa',
              '**** **** **** 8970',
              'Expires: 12/26',
              opacity: 1,
            ),
            SizedBox(
              height: context.responsiveHeight(8),
            ),
            _buildPaymentMethods(
              context,
              'mastercard',
              '**** **** **** 8970',
              'Expires: 12/26',
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Confirm',
              context: context,
              onPressed: () {},
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            )
          ],
        ),
      ),
    );
  }
}
