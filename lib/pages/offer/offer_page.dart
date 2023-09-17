import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/custom_app_bar.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

import '../../utils/theme/themes.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      body: BasePadding(
          context: context,
          child: ListView(
            children: [
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
              _buildContainer(context),
            ],
          )),
    );
  }

  Padding _buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppThemes.lightPrimary500,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/svg/offer.svg'),
            SizedBox(
              width: context.responsiveWidth(10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount 15% off',
                  style: context.textStyle.headlineSmallBold,
                ),
                Text(
                  'Special Promo valid for Black Friday',
                  style: context.textStyle.bodySmallMedium
                      .copyWith(color: HexColor('#B8B8B8')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
