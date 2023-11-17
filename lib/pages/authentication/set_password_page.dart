import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../controllers/authentiaction/authentication_controller.dart';
import '../../models/user/user_model.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class SetPasswordPage extends StatelessWidget {
  SetPasswordPage({super.key});

  final TextEditingController _confirmPasswordTextEditingController =
      TextEditingController();

  final AuthController _controller = AuthController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  late final UserModel _user;

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BasePadding(
        context: context,
        child: Column(
          children: [
            Text(
              'setPassword'.tr(),
              style: context.textStyle.titleMedMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(12),
            ),
            Text(
              'setYourPassword'.tr(),
              style: context.textStyle.bodyLargeRegular.copyWith(
                color: HexColor("#D0D0D0"),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(40),
            ),
            PasswordTextFormField(
              context: context,
              controller: _passwordTextEditingController,
              hintText: 'enterYourPassword'.tr(),
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            PasswordTextFormField(
              context: context,
              controller: _confirmPasswordTextEditingController,
              hintText: 'confirmPassword'.tr(),
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            Row(
              children: [
                SizedBox(
                  height: context.responsiveHeight(19),
                  width: context.responsiveWidth(277),
                  child: Text(
                    'passwordControl'.tr(),
                    style: context.textStyle.subheadSmallRegular.copyWith(
                      color: HexColor("#A6A6A6"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(43),
            ),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  PrimaryButton _buildRegisterButton(BuildContext context) {
    return PrimaryButton(
      text: 'register'.tr(),
      context: context,
      onPressed: () async {
        _user.password = _passwordTextEditingController.text;
        _user.passwordConfirmation = _confirmPasswordTextEditingController.text;
        await _controller.register(_user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: BackAppBar(context: context),
      body: _buildBody(context),
    );
  }
}
