import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    GlobalKey<ScaffoldState>? scaffoldKey,
    Text? title,
    required BuildContext context,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: title,
          titleTextStyle: context.textStyle.headlineSmallMedium.copyWith(color: HexColor("#2A2A2A")),
          centerTitle: true,
          leading: IconButton(
            // IconButton kullanıyoruz
            onPressed: () {
              scaffoldKey?.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu), // Icon widget'ı burada kullanılıyor
          ),
          actions: [
            IconButton(
              // IconButton kullanıyoruz
              onPressed: () {
                NavigationManager.instance.navigationToPage(
                  NavigationConstant.notification,
                );
              },
              icon: Icon(Icons.notifications_none_outlined), // Icon widget'ı burada kullanılıyor
            ),
            SizedBox(
              width: context.responsiveWidth(16),
            ),
          ],
        );
}
