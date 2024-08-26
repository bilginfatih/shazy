import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'controller/profile_controller.dart';
import '../../utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    _controller.init(context);
    super.initState();
  }

  Padding _buildCommentContainer(BuildContext context, String imagePath,
      String text1, String text2, double rating) {
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
                backgroundColor: Colors.white,
                child: _buildImage(imagePath),
              ),
              SizedBox(
                width: context.responsiveWidth(13),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: context.textStyle.subheadSmallRegular.copyWith(
                        color: context.isLight
                            ? HexColor('#121212')
                            : Colors.white),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(6),
                  ),
                  RatingBarIndicator(
                    rating: rating,
                    itemCount: 5,
                    itemSize: 15,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => SvgPicture.asset(
                      'assets/svg/star.svg',
                      width: context.responsiveWidth(20),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(7),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(200),
                    child: Text(
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      text2,
                      style: context.textStyle.bodySmallRegular.copyWith(
                          fontSize: 9,
                          color: context.isLight
                              ? HexColor('#5A5A5A')
                              : Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Observer _buildUserProfileRow(BuildContext context) {
    return Observer(builder: (_) {
      return Row(
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
                  backgroundColor: Colors.white,
                  child: _buildImage(_controller.imagePath),
                ),
              ),
              _controller.lisanceVertification
                  ? Positioned(
                      left: 100,
                      bottom: 14,
                      child: SvgPicture.asset(
                        'assets/svg/verified-user.svg',
                        width: context.responsiveWidth(20),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(
            width: context.responsiveWidth(15.82),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.name,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.titleLargeMedium.copyWith(
                    color:
                        context.isLight ? HexColor("#5A5A5A") : Colors.white),
              ),
              SizedBox(
                height: context.responsiveHeight(4),
              ),
              _buildEditButton(context),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              _buildShortDescription(context),
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
                  _buildProfileColumn(
                      _controller.star, 'rating'.tr(), context.isLight),
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
                  _buildProfileColumn(
                      _controller.reviews, 'reviews'.tr(), context.isLight),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  ClipOval _buildImage(String path) {
    return ClipOval(
      child: Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, exception, stackTrack) => Image.asset(
          'assets/png/no_data.png',
        ),
      ),
    );
  }

  Column _buildProfileColumn(String text1, String text2, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isLight ? HexColor("#5A5A5A") : Colors.white,
          ),
        ),
        Text(
          text2,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: isLight ? HexColor("#5A5A5A") : Colors.white,
          ),
        ),
      ],
    );
  }

  Row _buildShortDescription(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/png/driver_license.png'),
        SizedBox(
          width: context.responsiveWidth(7),
        ),
        Text(_controller.description),
      ],
    );
  }

  GestureDetector _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: _controller.goToEditPage,
      child: Container(
        decoration: ShapeDecoration(
          color: context.isLight ? Colors.white : HexColor('#35383F'),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFFD0D0D0)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.responsiveHeight(4),
            horizontal: context.responsiveWidth(25),
          ),
          child: Text(
            'editProfile'.tr(),
            style: TextStyle(
              color: context.isLight ? HexColor("#5A5A5A") : Colors.white,
              fontSize: context.responsiveFont(9),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildCommentList(BuildContext context) {
    return Expanded(
      child: Observer(
        builder: (_) => ListView.builder(
          itemCount: _controller.commentList.length,
          itemBuilder: (_, index) => _buildCommentContainer(
            context,
            _controller.commentList[index].imagePath.toString(),
            _controller.commentList[index].name.toString(),
            _controller.commentList[index].comment.toString(),
            _controller.commentList[index].point ?? 0.0,
          ),
        ),
      ),
    );
  }

  BasePadding _buildBody(BuildContext context) {
    return BasePadding(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // üst kısımdaki kullanıcı bilgileri alanı
          _buildUserProfileRow(context),
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
            'comments'.tr(),
            style: context.textStyle.subheadLargeSemibold,
          ),
          SizedBox(
            height: context.responsiveHeight(10),
          ),
          _buildCommentList(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: widget.scaffoldKey,
        title: Text(
          'profile'.tr(),
          style:
              TextStyle(color: context.isLight ? Colors.black : Colors.white),
        ),
      ),
      body: _buildBody(context),
    );
  }
}
