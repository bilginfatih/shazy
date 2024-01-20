import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/pages/profile/controller/profile_controller.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/app_bars/custom_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/textfields/email_text_form_field.dart';
import 'package:shazy/widgets/textfields/name_text_from_field.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/padding/base_padding.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({super.key});

  final ProfileController _controller = ProfileController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _aboutYouTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'profile'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: context.responsiveHeight(30),
            ),
            GestureDetector(
              onTap: (){
                
              },
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/png/no_data.png',
                        width: context.responsiveWidth(120),
                        height: context.responsiveHeight(127),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      bottom: 0,
                      child: SvgPicture.asset(
                        'assets/svg/camera-2.svg',
                        width: context.responsiveWidth(20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: context.responsiveHeight(47),
              ),
              child: NameTextFormField(
                hintText: 'fullName'.tr(),
                context: context,
                controller: _nameTextController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: context.responsiveHeight(20),
              ),
              child: EmailTextFormField(
                text: 'Email',
                context: context,
                controller: _emailTextController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: context.responsiveHeight(20),
              ),
              child: NameTextFormField(
                hintText: 'aboutYou'.tr(),
                context: context,
                controller: _aboutYouTextController,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(207),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SecondaryButton(
                  width: 174,
                  text: 'cancel'.tr(),
                  context: context,
                  onPressed: _controller.goToBackPage,
                ),
                PrimaryButton(
                  width: 174,
                  text: 'save'.tr(),
                  context: context,
                  onPressed: () {
                    // TODO: yapılacak.
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
