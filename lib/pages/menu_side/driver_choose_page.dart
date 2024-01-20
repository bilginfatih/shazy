import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
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
  final DriveService _driveService = DriveService(); // DriveService örneği
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, mainTitle: 'Driver'),
      body: Padding(
        padding: EdgeInsets.only(left: 46, top: 91),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/png/driver.png",
              width: context.responsiveWidth(280),
              height: context.responsiveHeight(280),
            ),
            SizedBox(
              height: context.responsiveHeight(63),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Viverra condimentum eget \npurus in.  ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: HexColor("#494949")),
            ),
            SizedBox(
              height: context.responsiveHeight(55),
            ),
            Row(
              children: [
                SecondaryButton(
                  context: context,
                  text: 'Not Fit',
                  height: context.responsiveHeight(54),
                  width: context.responsiveWidth(140),
                  style: TextStyle(color: HexColor("#414141")),
                  borderColor: HexColor("#414141"),
                  onPressed: () {},
                ),
                SizedBox(
                  width: context.responsiveWidth(13),
                ),
                SecondaryButton(
                  context: context,
                  text: 'Fit to Drive',
                  height: context.responsiveHeight(54),
                  width: context.responsiveWidth(140),
                  onPressed: () {
                    fitToDriveButtonPressed();
                    NavigationManager.instance.navigationToPage(NavigationConstant.homePage, args: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void fitToDriveButtonPressed() async {
    var userId = await SessionManager().get('id'); // SessionManager'daki uygun metod
    if (userId != null) {
      // Kullanıcının konumunu al
      Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
          // Hata durumunda kullanıcıya bildirim veya işlem yapabilirsiniz
          // Örneğin:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result),
          ));
        } else {
          // Başarılı durumda
          // Yapılacak işlemler...
        }
      } catch (e) {
        // Hata durumunda kullanıcıya bildirim veya işlem yapabilirsiniz
        // Örneğin:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error occurred: $e"),
        ));
      }
    } else {
      // Hata durumu, kullanıcı oturum açmamışsa veya ID alınamamışsa yapılacak işlemler
      print("Kullanıcı oturum açmamış veya ID alınamamış.");
    }
  }
}
