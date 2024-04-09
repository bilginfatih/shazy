import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/services/user/user_identity_service.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/theme/themes.dart';

class CustomDrawer extends SizedBox {
  CustomDrawer({
    Key? key,
    required BuildContext context,
    required String name,
    required String email,
  }) : super(
          key: key,
          width: context.customWidth(0.62),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(80),
                bottomRight: Radius.circular(80)),
            child: Drawer(
              backgroundColor:
                  context.isLight ? Colors.white : AppThemes.darkBg,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.responsiveHeight(50),
                      left: context.responsiveWidth(18),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        NavigationManager.instance.navigationToPop();
                      },
                      child: Row(
                        children: [
                          context.isLight
                              ? SvgPicture.asset('assets/svg/angle-left.svg')
                              : SvgPicture.asset(
                                  'assets/svg/angle-left_white.svg'),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Back',
                            style: context.textStyle.subheadLargeRegular
                                .copyWith(color: _getColor(context.isLight)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: context.responsiveHeight(27),
                        left: context.responsiveWidth(22),
                      ),
                      child: Container(
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
                          child: Image.asset('assets/png/no_data.png'),
                        ),
                      ),
                      /*Stack(
                        children: [
                          Container(
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
                            left: 50,
                            bottom: 0,
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: context.responsiveWidth(20),
                            ),
                          )
                        ],
                      ),*/
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.responsiveHeight(18),
                      left: context.responsiveWidth(22),
                    ),
                    child: Text(
                      name,
                      style: context.textStyle.headlineSmallMedium
                          .copyWith(color: _getColor(context.isLight)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.responsiveWidth(22),
                    ),
                    child: Text(
                      email,
                      style: context.textStyle.bodySmallMedium.copyWith(
                          color: context.isLight
                              ? HexColor('#414141').withOpacity(0.8)
                              : AppThemes.hintTextNeutral),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(24),
                  ),
                  _buildTextRow(context, 'assets/svg/car.svg', 'driver'.tr(),
                      () async {
                      NavigationManager.instance
                          .navigationToPage(NavigationConstant.driverChoose);
                    bool userIdentityCheck =
                        await UserIdentityService.instance.userIdentityCheck();
                    if (!userIdentityCheck ) {
                      NavigationManager.instance
                          .navigationToPage(NavigationConstant.driverAccept);
                    } else {
                      NavigationManager.instance
                          .navigationToPage(NavigationConstant.driverChoose);
                    }
                  }),
                  const Divider(
                    thickness: 0.2,
                  ),
                  _buildTextRow(
                      context, 'assets/svg/complain.svg', 'complain'.tr(), () {
                    NavigationManager.instance
                        .navigationToPage(NavigationConstant.complain);
                  }),
                  const Divider(
                    thickness: 0.2,
                  ),
                  _buildTextRow(
                      context, 'assets/svg/about-us.svg', 'aboutUs'.tr(), () {
                    NavigationManager.instance
                        .navigationToPage(NavigationConstant.aboutUs);
                  }),
                  const Divider(
                    thickness: 0.2,
                  ),
                  _buildTextRow(
                      context, 'assets/svg/settings.svg', 'settings'.tr(), () {
                    NavigationManager.instance
                        .navigationToPage(NavigationConstant.settings);
                  }),
                  const Divider(
                    thickness: 0.2,
                  ),
                  _buildTextRow(context, 'assets/svg/logout.svg', 'logout'.tr(),
                      UserService.instance.logout),
                ],
              ),
            ),
          ),
        );

  static Color _getColor(isLight) =>
      isLight ? HexColor('#414141').withOpacity(0.8) : Colors.white;

  static Padding _buildTextRow(
      BuildContext context, String asset, String text, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(16),
        bottom: context.responsiveHeight(16),
        left: context.responsiveWidth(22),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              asset,
              colorFilter: context.isLight
                  ? null
                  : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(
              width: context.responsiveHeight(8),
            ),
            Text(
              text,
              style: context.textStyle.labelSmallMedium
                  .copyWith(color: _getColor(context.isLight)),
            ),
          ],
        ),
      ),
    );
  }
}
