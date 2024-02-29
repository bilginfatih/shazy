import 'package:flutter/material.dart';

import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

/*
  Padding _buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(context.responsiveWidth(20)),
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
                FittedBox(
                  child: Text(
                    'Discount 15% off',
                    style: context.textStyle.headlineSmallBold,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Special Promo valid for Black Friday',
                    maxLines: 2,
                    style: context.textStyle.bodySmallMedium
                        .copyWith(color: HexColor('#B8B8B8')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: scaffoldKey,
      ),
      /*body: BasePadding(
        context: context,
        child: ListView(
          children: [
            _buildContainer(context),
          ],
        ),
      ), */
    );
  }
}
