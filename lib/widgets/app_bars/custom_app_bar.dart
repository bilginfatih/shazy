import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../buttons/shadow_button.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required BuildContext context,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShadowButton(
              context: context,
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onTap: () {},
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShadowButton(
                context: context,
                icon: SvgPicture.asset(
                  'assets/svg/notification.svg',
                ),
                onTap: () {},
              ),
            )
          ],
        );
}
