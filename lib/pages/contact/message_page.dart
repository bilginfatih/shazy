import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/padding/base_padding.dart';

// TODO: back-end tamamlandıktan sonra builder yapısı olucak ve tarih eklenecek
class MessagePage extends StatelessWidget {
  MessagePage({super.key});

  double _keyboardSize = 0;

  Align _buildChatText(BuildContext context, String text) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(left: context.responsiveWidth(78)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            border: Border.all(color: AppThemes.lightPrimary500),
            color: AppThemes.lightPrimary50,
          ),
          child: Text(
            text,
            style: context.textStyle.bodyMediumRegular,
          ),
        ),
      ),
    );
  }

  Flexible _buildChatTextOtherPerson(BuildContext context, String text) =>
      Flexible(
        child: Padding(
          padding: EdgeInsets.only(right: context.responsiveWidth(78)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              color: HexColor('#E8E8E8'),
            ),
            child: Text(
              text,
              style: context.textStyle.bodyMediumRegular,
            ),
          ),
        ),
      );

  Row _buildChatTextFormField(BuildContext context) => Row(
        children: [
          _buildIconButton(() {}, 'assets/svg/plus.svg', true),
          Expanded(
            child: Container(
              constraints:
                  BoxConstraints(maxHeight: context.responsiveHeight(120)),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  hintStyle: context.textStyle.subheadLargeMedium.copyWith(
                    color: AppThemes.hintTextNeutral,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/smile-face.svg',
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppThemes.borderSideColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildIconButton(() {}, 'assets/svg/send.svg', false),
        ],
      );

  GestureDetector _buildIconButton(
          VoidCallback onTap, String path, bool isPrefix) =>
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
              right: (isPrefix ? 7 : 0), left: (!isPrefix ? 7 : 0)),
          child: SvgPicture.asset(path),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Chat',
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            SizedBox(
              height: context.responsiveHeight(
                  _keyboardSize == 0 ? 625 : 650 - _keyboardSize),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.responsiveWidth(36),
                        height: context.responsiveHeight(36),
                        child: const CircleAvatar(),
                      ),
                      SizedBox(
                        width: context.responsiveWidth(12),
                      ),
                      _buildChatTextOtherPerson(
                        context,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ut metus molestie mi maximus volutpat sed quis nulla. Aliquam suscipit id ante vel vulputate. Integer quis metus id orci iaculis aliquam sed ut odio. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus varius tincidunt nisl sed dignissim. Pellentesque a pretium est. Sed malesuada gravida vestibulum. Sed non quam leo. Nunc pretium risus ut ligula pretium cursus.",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.responsiveHeight(30),
                  ),
                  _buildChatText(context, 'test'),
                ],
              ),
            ),
            const Spacer(),
            _buildChatTextFormField(context),
            SizedBox(
              height: context.responsiveHeight(
                  _keyboardSize == 0 ? 16 : _keyboardSize - 12),
            )
          ],
        ),
      ),
    );
  }
}
