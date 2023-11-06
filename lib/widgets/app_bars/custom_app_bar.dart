import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../buttons/shadow_button.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    GlobalKey<ScaffoldState>? scaffoldKey,
    required BuildContext context,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leadingWidth: 100,
          leading: Row(
            children: [
              SizedBox(
                width: context.responsiveWidth(6),
              ),
              Padding(
                padding: EdgeInsets.all(context.responsiveWidth(12)),
                child: ShadowButton(
                  context: context,
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onTap: () {
                    scaffoldKey?.currentState?.openDrawer();
                  },
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(context.responsiveWidth(12)),
              child: ShadowButton(
                context: context,
                icon: SvgPicture.asset(
                  'assets/svg/notification.svg',
                ),
                onTap: () {},
              ),
            ),
            SizedBox(
              width: context.responsiveWidth(6),
            ),
          ],
        );
}
