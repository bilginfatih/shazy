import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'controller/wallet_controller.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

import '../../utils/theme/themes.dart';

class WalletPage extends StatefulWidget {
  WalletPage({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;
  static int incomeLength = 0;
  static int outgoneLength = 0;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String userId = '';

  final WalletController _controller = WalletController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    userId = await SessionManager().get('id');
    _controller.getFinance(userId);
  }

  Padding _buildTransectionContainer(BuildContext context, text1, text2, text3, String path) {
    Color textColor1 = context.isLight ? HexColor('#121212') : HexColor('#D0D0D0');
    Color textColor2 = context.isLight ? HexColor('#5A5A5A') : HexColor('#B8B8B8');
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
                    style: context.textStyle.subheadSmallRegular.copyWith(color: textColor1),
                  ),
                  Text(
                    text2,
                    style: context.textStyle.bodySmallRegular.copyWith(color: textColor2),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                text3,
                style: context.textStyle.bodyMedium.copyWith(color: textColor1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildTopContainer(BuildContext context, String text1, String text2, Color color, bool isSelected, bool selectValue) {
    double width = context.width;
    return GestureDetector(
      onTap: () async {
        _controller.select(selectValue);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: context.responsiveHeight(36.0),
            //horizontal: context.customWidth(width < 390 ? 0.06 : 0.078)),
            horizontal: context.customWidth(width < 390 ? 0.1 : 0.078)),
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
              style: context.textStyle.subheadSmallMedium.copyWith(
                color: color,
              ),
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
        scaffoldKey: widget.scaffoldKey,
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (_) {
              if (_controller.financeList.isEmpty) {
                return const SizedBox(); // veya başka bir yükleme göstergesi
              } else {
                return Row(
                  children: [
                    _buildTopContainer(context, '${_controller.financeList[_controller.financeList.length - 1].total_income}₺', 'Total Income',
                        AppThemes.success700, _controller.isSelectedIncome, true),
                    const Spacer(),
                    _buildTopContainer(context, '${_controller.financeList[_controller.financeList.length - 1].total_expend}₺', 'Total Expend',
                        AppThemes.error700, !_controller.isSelectedIncome, false),
                  ],
                );
              }
            }),
            SizedBox(
              height: context.responsiveHeight(30),
            ),
            _controller.financeList.isEmpty
                ? const SizedBox()
                : Text(
                    'Transections',
                    style: context.textStyle.subheadLargeSemibold,
                  ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            Observer(builder: (_) {
              if (_controller.financeList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List incomeDate = [];
                List income = [];
                List outgoneDate = [];
                List outgone = [];
                incomeDate.add(_controller.financeList[WalletPage.incomeLength].organize_income_date);
                income.add(_controller.financeList[WalletPage.incomeLength].organize_income);
                outgoneDate.add(_controller.financeList[WalletPage.incomeLength].organize_outgone_date);
                outgone.add(_controller.financeList[WalletPage.incomeLength].organize_outgone);
                return Expanded(
                  child: _controller.isSelectedIncome
                      ? ListView.builder(
                          itemCount: WalletPage.incomeLength,
                          itemBuilder: (_, int index) {
                            return _buildTransectionContainer(context, 'Nathsam', '${incomeDate[0][index]}', '${income[0][index]}₺', 'down');
                          },
                        )
                      : ListView.builder(
                          itemCount: WalletPage.outgoneLength,
                          itemBuilder: (_, int index) {
                            return _buildTransectionContainer(context, 'Nathsam', '${outgoneDate[0][index]}', '-${outgone[0][index]}₺', 'up');
                          },
                        ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
