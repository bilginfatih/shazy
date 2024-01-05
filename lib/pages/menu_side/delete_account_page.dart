import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';

class DeleteAccountPage extends StatefulWidget {
  DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Delete Account',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 14, 20),
        child: Column(
          children: [
            Text(
              'Are you sure you want to delete your account? Please read how account deletion will affect. Deleting your account removes personal information our database. Tour email becomes permanently reserved and same email cannot be re-use to register a new account.',
              style: context.textStyle.bodyMediumRegular.copyWith(
                color: HexColor("#5A5A5A"),
              ), // İstediğiniz metin boyutunu ayarlayabilirsiniz.
            ),
            SizedBox(height: context.responsiveHeight(30)),
            PrimaryButton(
              context: context,
              text: 'Delete',
              buttonStyle: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
