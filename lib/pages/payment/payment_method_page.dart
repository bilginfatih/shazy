import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../models/drive/drive_model.dart';
import 'package:shazy/pages/payment/controller/payment_controller.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/containers/payment_method_container.dart';
import '../../core/base/app_info.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/padding/base_padding.dart';
import '../home/home_screen_transport.dart';

class PaymetnMethodPage extends StatefulWidget {
  const PaymetnMethodPage({super.key});

  @override
  State<PaymetnMethodPage> createState() => _PaymetnMethodPageState();
}

class _PaymetnMethodPageState extends State<PaymetnMethodPage> {
  DriveModel driveDetailsInfo = DriveModel();

  final PaymentController _controller = PaymentController();

  @override
  void initState() {
    _controller.init();
    super.initState();
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

  GestureDetector _buildAddCardButton(BuildContext context) {
    return GestureDetector(
      onTap: _controller.goToAddCardPage,
      child: Text(
        'addCard'.tr(),
        style: context.textStyle.subheadLargeSemibold.copyWith(
          color: AppThemes.secondary700.withOpacity(0.6),
        ),
      ),
    );
  }

  SingleChildRenderObjectWidget _buildPaymentMethod(BuildContext context) {
    return _controller.card.cardNumber != null &&
            _controller.card.month != null &&
            _controller.card.year != null
        ? PaymetMethodContainer(
            context: context,
            //assetName: 'visa',
            text1:
                '**** **** **** ${_controller.card.cardNumber?.substring(_controller.card.cardNumber!.length - 5)}',
            text2:
                'Expires: ${_controller.card.month}/${_controller.card.year}',
            opacitiy: 1,
          )
        : Center(
            child: Text(
              'noPaymentMethod'.tr(),
              style: context.textStyle.titleSmallMedium
                  .copyWith(color: HexColor('#898989')),
            ),
          );
  }

  PrimaryButton _buildConfirmButton(BuildContext context) {
    return PrimaryButton(
      text: 'Confirm',
      context: context,
      onPressed: () async {
        // TODO: go to bilmem ne page y
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userDropOffLocation = Provider.of<AppInfo>(context).userDropOffLocation;
    var dropOffLocationName = userDropOffLocation?.locationName;

    if (dropOffLocationName != null && dropOffLocationName.length > 24) {
      dropOffLocationName = dropOffLocationName.substring(0, 24);
    }

    dropOffLocationName ??= 'undefined';

    var currentLocationName = userDropOffLocation?.currentLocationName;

    if (currentLocationName != null && currentLocationName.length > 24) {
      currentLocationName = currentLocationName.substring(0, 24);
    }

    currentLocationName ??= 'undefined';
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Request for driver'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Observer(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationRow(
                context,
                'map2',
                'currentLocation'.tr(),
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? "${Provider.of<AppInfo>(context).userPickUpLocation!.locationName.toString().substring(0, 24)}..."
                    : 'undefined',
              ),
              SizedBox(
                height: context.responsiveHeight(29),
              ),
              _buildLocationRow(
                context,
                'map3',
                dropOffLocationName.toString(),
                currentLocationName.toString(),
                text3: '2.7km',
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              Text(
                'orderSummary'.tr(),
                style: context.textStyle.subheadLargeMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              _buildPriceRow(context, 'charge'.tr(), '200₺'),
              /*SizedBox(
                height: context.responsiveHeight(9),
              ),
              _buildPriceRow(context, 'commission'.tr(), '20₺'),
              SizedBox(
                height: context.responsiveHeight(9),
              ),
              _buildPriceRow(context, 'totalAmount'.tr(), '220₺'),*/
              SizedBox(
                height: context.responsiveHeight(20),
              ), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'selectPaymentMethod'.tr(),
                    style: context.textStyle.headlineSmallMedium.copyWith(
                      color: HexColor('#5A5A5A'),
                    ),
                  ),
                  _buildAddCardButton(context),
                ],
              ),
              SizedBox(
                height: context.responsiveHeight(26),
              ),
              _buildPaymentMethod(context),
              const Spacer(),
              _buildConfirmButton(context),
              SizedBox(
                height: context.responsiveHeight(16),
              )
            ],
          );
        }),
      ),
    );
  }
}
