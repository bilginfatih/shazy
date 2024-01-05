import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/country_phone_text_form_field.dart';
import '../../widgets/textfields/email_text_form_field.dart';
import '../../widgets/textfields/name_text_from_field.dart';
import '../../widgets/textfields/write_text_field.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _phoneTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, mainTitle: 'Contact Us'),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: context.responsiveHeight(30),
                ),
                Text(
                  'Contact us for Ride share',
                  style: context.textStyle.headlineSmallMedium,
                ),
                SizedBox(
                  height: context.responsiveHeight(16),
                ),
                Text(
                  'Address',
                  style: context.textStyle.subheadLargeMedium,
                ),
                SizedBox(
                  height: context.responsiveHeight(4),
                ),
                Text(
                  'House# 72, Road# 21, Banani, Dhaka-1213 (near Banani Bidyaniketon School & \nCollege, beside University of South Asia)\n \nCall : 13301 (24/7)\nEmail : support@pathao.com',
                  style: context.textStyle.bodySmallMedium.copyWith(
                    color: HexColor("#898989"),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: context.responsiveHeight(15),
                ),
                Text(
                  'Send Message',
                  style: context.textStyle.subheadLargeMedium,
                ),
                SizedBox(
                  height: context.responsiveHeight(16),
                ),
                NameTextFormField(
                  context: context,
                  hintText: 'Name',
                ),
                SizedBox(
                  height: context.responsiveHeight(16),
                ),
                EmailTextFormField(
                  context: context,
                  text: 'Email',
                ),
                SizedBox(
                  height: context.responsiveHeight(16),
                ),
                CountryPhoneTextFormField(
                  context: context,
                  controller: _phoneTextEditingController,
                ),
                SizedBox(
                  height: context.responsiveHeight(16),
                ),
                WriteTextField(
                  context: context,
                  hintText: 'Write your text',
                  maxLines: 5,
                  borderColor: HexColor("#B8B8B8"),
                ),
                SizedBox(
                  height: context.responsiveHeight(29),
                ),
                PrimaryButton(
                  context: context,
                  text: 'Send',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
