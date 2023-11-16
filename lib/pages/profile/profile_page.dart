import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/pages/profile/controller/profile_controller.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileController _controller = ProfileController();

  Padding _buildTransectionContainer(BuildContext context, text1, text2) {
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
              CircleAvatar(
                radius: 32,
                child: Image.asset('assets/png/no_data.png'),
                backgroundColor: Colors.white,
              ),
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
                  SizedBox(
                    height: context.responsiveHeight(6),
                  ),
                  RatingBar.builder(
                    initialRating: 3.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 15,
                    updateOnDrag: false,
                    tapOnlyMode: false,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => SvgPicture.asset(
                      'assets/svg/star.svg',
                      width: context.responsiveWidth(20),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(
                    height: context.responsiveHeight(7),
                  ),
                  Text(
                    text2,
                    style: context.textStyle.bodySmallRegular
                        .copyWith(color: HexColor('#5A5A5A')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: _scaffoldKey,
        title: Text("Profile"),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: context.responsiveHeight(130),
                      width: context.responsiveWidth(124),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppThemes.lightPrimary500,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        child: Image.asset('assets/png/no_data.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 100,
                      bottom: 14,
                      child: SvgPicture.asset(
                        'assets/svg/verified-user.svg',
                        width: context.responsiveWidth(20),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: context.responsiveWidth(15.82),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Elif X.",
                      style: context.textStyle.titleLargeMedium
                          .copyWith(color: HexColor("#5A5A5A")),
                    ),
                    SizedBox(
                      height: context.responsiveHeight(31),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/car.svg',
                          width: context.responsiveWidth(20),
                        ),
                        SizedBox(
                          width: context.responsiveWidth(7),
                        ),
                        Text("Sürücü Hakkında Yazı"),
                      ],
                    ),
                    SizedBox(
                      height: context.responsiveHeight(15),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7.0),
                          child: SvgPicture.asset(
                            'assets/svg/star.svg',
                            width: context.responsiveWidth(20),
                          ),
                        ),
                        SizedBox(
                          width: context.responsiveWidth(6.4),
                        ),
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: HexColor("#5A5A5A"),
                          ),
                        ),
                        SizedBox(
                          width: context.responsiveWidth(23.87),
                        ),
                        Container(
                          height: context.responsiveHeight(41),
                          width: context.responsiveWidth(1),
                          color: HexColor('#DDDDDD'),
                        ),
                        SizedBox(
                          width: context.responsiveWidth(25),
                        ),
                        Text(
                          "531",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: HexColor("#5A5A5A"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Rating",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: HexColor("#5A5A5A"),
                          ),
                        ),
                        SizedBox(
                          width: context.responsiveWidth(65),
                        ),
                        Text(
                          "Reviews",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: HexColor("#5A5A5A"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(14),
            ),
            Container(
              height: context.responsiveHeight(1),
              width: context.responsiveWidth(392),
              color: HexColor('#DDDDDD'),
            ),
            SizedBox(
              height: context.responsiveHeight(25),
            ),
            Text(
              "Comments",
              style: context.textStyle.subheadLargeSemibold,
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                  _buildTransectionContainer(
                      context, 'Nathsam', 'Lorem ipsum dolor sit amet,'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
