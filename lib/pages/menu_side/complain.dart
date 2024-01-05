import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/dialogs/congratulation_dialog.dart';
import '../../widgets/textfields/write_text_field.dart';

class ComplainPage extends StatefulWidget {
  ComplainPage({Key? key}) : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Complain',
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 15.0),
        child: Column(
          children: [
            Container(
              width: context.responsiveWidth(362),
              height: context.responsiveHeight(118),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: WriteTextField(
                context: context,
                hintText: 'Write your complaint here (minimum 10 characters)',
                borderColor: HexColor("#B8B8B8"),
                maxLines: 5,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(32),
            ),
            PrimaryButton(
              context: context,
              text: 'Submit',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessDialog(
                      context: context,
                      text1: 'Your complain has been send successful',
                      title: 'Send successful',
                      widget: PrimaryButton(
                        context: context,
                        text: 'Back Home',
                        onPressed: () {},
                        width: context.responsiveWidth(340),
                        height: context.responsiveHeight(54),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
