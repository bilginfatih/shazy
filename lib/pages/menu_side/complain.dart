import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/models/complain/complain_model.dart';
import 'package:shazy/services/complain/complain_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../utils/helper/helper_functions.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/dialogs/congratulation_dialog.dart';
import '../../widgets/textfields/write_text_field.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({Key? key}) : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final TextEditingController _textController = TextEditingController();

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.responsiveHeight(30.0),
          left: context.responsiveWidth(15.0)),
      child: Column(
        children: [
          _buildTextField(context),
          SizedBox(
            height: context.responsiveHeight(32),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  PrimaryButton _buildButton(BuildContext context) {
    return PrimaryButton(
      context: context,
      text: 'submit'.tr(),
      onPressed: () async {
        var response = await ComplainService.instance.postComplain(
          ComplainModel(
            complain: _textController.text,
          ),
        );
        if (response != null) {
          if (context.mounted) {
            HelperFunctions.instance
                .showErrorDialog(context, response, 'backHome'.tr(), () {
              NavigationManager.instance
                  .navigationToPageClear(NavigationConstant.homePage);
            });
          }
        } else if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                context: context,
                text1: 'complainSuccessText'.tr(),
                title: 'sendSuccessful'.tr(),
                widget: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsiveWidth(20)),
                  child: PrimaryButton(
                    context: context,
                    text: 'backHome'.tr(),
                    onPressed: () {
                      NavigationManager.instance.navigationToPop();
                    },
                    width: context.responsiveWidth(340),
                    height: context.responsiveHeight(54),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Container _buildTextField(BuildContext context) {
    return Container(
      width: context.responsiveWidth(362),
      height: context.responsiveHeight(118),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: WriteTextField(
        controller: _textController,
        context: context,
        hintText: 'complainHintText'.tr(),
        borderColor: HexColor("#B8B8B8"),
        maxLines: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'complain'.tr(),
      ),
      body: _buildBody(context),
    );
  }
}
