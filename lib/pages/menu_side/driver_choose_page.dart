import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/padding/base_padding.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../models/drive/drive_model.dart';
import '../../services/drive/drive_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/secondary_button.dart';

class DriverChoosePage extends StatefulWidget {
  DriverChoosePage({Key? key}) : super(key: key);

  @override
  State<DriverChoosePage> createState() => _DriverChoosePageState();
}

class _DriverChoosePageState extends State<DriverChoosePage> {
  final DriveService _driveService = DriveService();
  String _choosePick = 'Driver_logo_gray1x';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, mainTitle: 'Driver'),
      body: BasePadding(
        context: context,
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/png/$_choosePick.png",
                width: context.responsiveWidth(280),
                height: context.responsiveHeight(280),
              ),
              SizedBox(
                height: context.responsiveHeight(63),
              ),
              Text(
                'driverChooseDesc'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: HexColor(context.isLight ? '#494949' : '#B8B8B8'),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(55),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SecondaryButton(
                    context: context,
                    text: 'notFit'.tr(),
                    height: context.responsiveHeight(54),
                    width: context.responsiveWidth(140),
                    style: TextStyle(color: HexColor("#414141")),
                    borderColor: HexColor("#414141"),
                    onPressed: () {
                      setState(() {
                        _choosePick = 'Driver_logo_gray1x';
                      });
                    },
                  ),
                  SecondaryButton(
                    context: context,
                    text: 'fitToDrive'.tr(),
                    height: context.responsiveHeight(54),
                    width: context.responsiveWidth(140),
                    onPressed: () {
                      setState(() {
                        _choosePick = 'Driver_logo_purple1x';
                      });
                      int countdownValue = Hive.box<int>('countdownBox')
                              .get('countdownValue', defaultValue: 0) ??
                          0;

                      if (countdownValue > 0) {
                        // Geri sayım devam ediyorsa, kullanıcıyı CancelDrive sayfasına yönlendir
                        NavigationManager.instance
                            .navigationToPage(NavigationConstant.cancelDrive);
                      } else {
                        // Geri sayım bitmişse, fitToDriveButtonPressed fonksiyonunu çağır ve kullanıcıyı homePage'e yönlendir
                        fitToDriveButtonPressed();
                        NavigationManager.instance.navigationToPage(
                            NavigationConstant.homePage,
                            args: true);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fitToDriveButtonPressed() async {
    var userId =
        await SessionManager().get('id'); // SessionManager'daki uygun metod
    if (userId != null) {
      // Kullanıcının konumunu al
      Position cPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // DriveModel oluştur ve servisi çağır
      DriveModel model = DriveModel(
        driverId: userId,
        driverLat: cPosition.latitude,
        driverLang: cPosition.longitude,
      );

      try {
        // DriverActive servisini çağır
        String? result = await _driveService.driverActive(model);

        // Sonucu kontrol et
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result),
          ));
        } else {
          // Başarılı durumda
          // Yapılacak işlemler...
        }
      } catch (e) {}
    } else {
      // Hata durumu, kullanıcı oturum açmamışsa veya ID alınamamışsa yapılacak işlemler
      print("Kullanıcı oturum açmamış veya ID alınamamış.");
    }
  }
}
