import 'package:flutter/material.dart';

class CustomIconButton extends Positioned {
  CustomIconButton({
    Key? key,
    double? width,
    double? height,
    double? size,
    double? top,
    double? left,
    double? right,
    double? bottom,
    Color? color,
    IconData? icon,
    VoidCallback? onPressed,
    required BuildContext context,
  }) : super(
          key: key,
          top: top,
          right: right,
          left: left,
          bottom: bottom,
          child: Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Kabartma rengi ve opaklık
                      spreadRadius: 2, // Ne kadar genişlemesi gerektiği
                      blurRadius: 4, // Görüntü bulanıklığı
                      offset:
                          const Offset(0, 2), // X ve Y eksenindeki ofset değeri
                    ),
                  ],
                ),
                height: height,
                width: width,
                child: IconButton(
                  padding: const EdgeInsets.all(5),
                  icon: Icon(
                    icon,
                    color: color,
                    size: size,
                  ),
                  onPressed: () {
                    if (icon == Icons.menu) {
                      Scaffold.of(context).openDrawer();
                    }
                    if (onPressed != null) onPressed();
                  },
                ),
              );
            },
          ),
        );
}
