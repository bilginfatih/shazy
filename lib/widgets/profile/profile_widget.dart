import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppThemes.lightPrimary500;
    final responsiveHeight = context.responsiveHeight(121);
    final responsiveWidth = context.responsiveWidth(121);

    return Center(
      child: Stack(
        children: [
          buildImage(responsiveWidth, responsiveHeight),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage(responsiveWidth, responsiveHeight) {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: responsiveWidth,
          height: responsiveHeight,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => BuildCircle(
      all: 8,
      color: color,
      child: const Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
        size: 20,
      ));

  Widget BuildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
