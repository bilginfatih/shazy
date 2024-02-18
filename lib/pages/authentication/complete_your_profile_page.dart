import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/profile/profile_widget.dart';
import '../../widgets/textfields/country_phone_text_form_field.dart';
import '../../widgets/textfields/email_text_form_field.dart';
import '../../widgets/textfields/gender_text_from_field.dart';
import '../../widgets/textfields/name_text_from_field.dart';

class CompleteYourProfilePage extends StatefulWidget {
  CompleteYourProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteYourProfilePage> createState() => _CompleteYourProfilePageState();
}

class _CompleteYourProfilePageState extends State<CompleteYourProfilePage> {
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'profile'.tr(),
      ),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Column(
            children: [
              ProfileWidget(
                imagePath: "https://randomuser.me/api/portraits/men/93.jpg",
                onClicked: () async {},
              ),
              SizedBox(
                height: context.responsiveHeight(30),
              ),
              NameTextFormField(
                context: context,
                controller: _nameController,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CountryPhoneTextFormField(
                context: context,
              ),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              EmailTextFormField(
                context: context,
                text: 'email'.tr(),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              EmailTextFormField(
                context: context,
                text: 'street'.tr(),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              GenderTextFormField(
                context: context,
                text: 'city'.tr(),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              GenderTextFormField(
                context: context,
                text: 'district'.tr(),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              Row(
                children: [
                  SecondaryButton(
                    context: context,
                    onPressed: () {},
                    text: 'cancel'.tr(),
                    height: context.responsiveHeight(54),
                    width: context.responsiveWidth(174),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(15),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      context: context,
                      onPressed: () {},
                      text: 'save'.tr(),
                      height: context.responsiveHeight(54),
                      width: context.responsiveWidth(174),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
