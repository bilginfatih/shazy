import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/widgets/buttons/icon_button.dart';
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
          scrolledUnderElevation: 0,
          elevation: 0,
          leadingWidth: context.responsiveWidth(100),
          title: title,
          titleTextStyle: context.textStyle.headlineSmallMedium
              .copyWith(color: HexColor("#2A2A2A")),
          centerTitle: true,
          leading: Row(
            children: [
              SizedBox(
                width: context.responsiveWidth(16),
              ),
              CustomIconButton(
                context: context,
                height: context.responsiveHeight(34),
                width: context.responsiveHeight(34),
                icon: Icons.menu,
                color: Colors.black,
                size: context.responsiveHeight(18),
                onPressed: () {
                  scaffoldKey?.currentState?.openDrawer();
                },
              ),
            ],
          ),
          actions: [
            CustomIconButton(
              context: context,
              height: context.responsiveHeight(34),
              width: context.responsiveHeight(34),
              icon: Icons.notifications_none_outlined,
              color: Colors.black,
              size: context.responsiveHeight(18),
              onPressed: () {
                NavigationManager.instance.navigationToPage(
                  NavigationConstant.notification,
                );
              },
            ),
            SizedBox(
              width: context.responsiveWidth(16),
            ),
          ],
        );
}
