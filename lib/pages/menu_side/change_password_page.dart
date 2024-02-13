import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/helper/helper_functions.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final TextEditingController _newPasswordTextController =
      TextEditingController();

  final TextEditingController _oldPasswordTextController =
      TextEditingController();

  Future<void> _onPressed(BuildContext context) async {
    if (_confirmPasswordTextController.text !=
        _newPasswordTextController.text) {
      HelperFunctions.instance
          .showErrorDialog(context, 'passwordNotSame'.tr(), 'cancel'.tr(), () {
        NavigationManager.instance.navigationToPop();
      });
    } else if (_oldPasswordTextController.text ==
        _newPasswordTextController.text) {
      HelperFunctions.instance.showErrorDialog(
          context, 'oldPasswordSameError'.tr(), 'cancel'.tr(), () {
        NavigationManager.instance.navigationToPop();
      });
    } else {
      await UserService.instance.changePassword(
          _oldPasswordTextController.text, _newPasswordTextController.text);
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'changePassword'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            PasswordTextFormField(
              context: context,
              hintText: 'oldPassword'.tr(),
              controller: _oldPasswordTextController,
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            PasswordTextFormField(
              context: context,
              hintText: 'newPassword'.tr(),
              controller: _newPasswordTextController,
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            PasswordTextFormField(
              context: context,
              hintText: 'confirmPassword'.tr(),
              controller: _confirmPasswordTextController,
            ),
            SizedBox(
              height: context.responsiveHeight(32),
            ),
            PrimaryButton(
              context: context,
              text: 'save'.tr(),
              onPressed: () async {
                await _onPressed(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
