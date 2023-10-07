import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Notification',
      ),
      body: BasePadding(
        context: context,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: context.isLight ? Colors.white : HexColor('#35383F'),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      'Payment Successfully!',
                      style: context.textStyle.subheadLargeSemibold.copyWith(
                          color: context.isLight
                              ? HexColor('#121212')
                              : Colors.white),
                    ),
                    subtitle: Text(
                      'Lorem ipsum dolor sit amet consectetur. Ultrici es tincidunt eleifend vitae',
                      style: context.textStyle.bodySmallRegular.copyWith(
                        color: context.isLight
                            ? HexColor('#898989')
                            : HexColor('#D0D0D0'),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
