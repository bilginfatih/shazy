import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'controller/wallet_controller.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

import '../../utils/theme/themes.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  final WalletController _controller = WalletController();

  Padding _buildTransectionContainer(
      BuildContext context, text1, text2, text3, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppThemes.lightPrimary500,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: context.responsiveHeight(12),
            bottom: context.responsiveHeight(12),
            left: context.responsiveWidth(12),
            right: context.responsiveWidth(17),
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/$path.svg'),
              SizedBox(
                width: context.responsiveWidth(13),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: context.textStyle.subheadSmallRegular
                        .copyWith(color: HexColor('#121212')),
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
                style: context.textStyle.bodyMedium
                    .copyWith(color: HexColor('#121212')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildTopContainer(BuildContext context, String text1,
      String text2, Color color, bool isSelected, bool selectValue) {
    double width = context.width;
    print(width);
    return GestureDetector(
      onTap: () {
        _controller.select(selectValue);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: context.responsiveHeight(36.0),
            horizontal: context.customWidth(width < 330 ? 0.06 : 0.088)),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : HexColor('#D0D0D0'),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              text1,
              style: context.textStyle.titleLargeMedium.copyWith(color: color),
            ),
            Text(
              text2,
              style:
                  context.textStyle.subheadSmallMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: scaffoldKey,
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (_) {
              return Row(
                children: [
                  _buildTopContainer(context, '\$500', 'Total Income',
                      AppThemes.success700, _controller.isSelectedIncome, true),
                  SizedBox(
                    width: context.responsiveWidth(30),
                  ),
                  _buildTopContainer(context, '\$200', 'Total Expend',
                      AppThemes.error700, !_controller.isSelectedIncome, false),
                ],
              );
            }),
            SizedBox(
              height: context.responsiveHeight(30),
            ),
            Text(
              'Transections',
              style: context.textStyle.subheadLargeSemibold,
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            Observer(builder: (_) {
              return Expanded(
                child: _controller.isSelectedIncome
                    ? ListView.builder(
                        itemCount: 10,
                        itemBuilder: (_, int index) {
                          return _buildTransectionContainer(context, 'Nathsam',
                              'Today at 09:20 am', '\$570.00', 'down');
                        },
                      )
                    : ListView.builder(
                        itemCount: 10,
                        itemBuilder: (_, int index) {
                          return _buildTransectionContainer(context, 'Nathsam',
                              'Today at 09:20 am', '-\$570.00', 'up');
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
