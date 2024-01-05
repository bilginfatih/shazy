import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/secondary_button.dart';

class DriverChoosePage extends StatefulWidget {
  DriverChoosePage({Key? key}) : super(key: key);

  @override
  State<DriverChoosePage> createState() => _DriverChoosePageState();
}

class _DriverChoosePageState extends State<DriverChoosePage> {
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
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
