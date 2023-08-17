import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/padding/base_padding.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Column(
            children: [
              SizedBox(
                height: context.responsiveHeight(270),
              ),
              Text(
                'Welcome',
                style: context.textStyle.titleMedMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(12),
              ),
              Text(
                'description',
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor("#D0D0D0"),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(201),
              ),
              PrimaryButton(
                context: context,
                text: 'Create an account',
                onPressed: () {},
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              SecondaryButton(
                context: context,
                text: 'Log In',
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
