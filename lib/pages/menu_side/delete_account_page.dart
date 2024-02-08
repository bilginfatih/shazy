import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'deleteAccount'.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 14, 20),
        child: Column(
          children: [
            Text(
              'deleteAccountDescription'.tr(),
              style: context.textStyle.bodyMediumRegular.copyWith(
                color: HexColor("#5A5A5A"),
              ), // İstediğiniz metin boyutunu ayarlayabilirsiniz.
            ),
            SizedBox(height: context.responsiveHeight(30)),
            PrimaryButton(
              context: context,
              text: 'delete'.tr(),
              buttonStyle: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                var response = await UserService.instance.deleteAccount();
                if (response != null) {
                  // TODO: hata mesajı
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
