import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../../widgets/app_bars/back_app_bar.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/padding/base_padding.dart';
import '../../../widgets/textfields/name_text_from_field.dart';

class DriverLicance extends StatefulWidget {
  DriverLicance({Key? key}) : super(key: key);

  @override
  State<DriverLicance> createState() => _DriverLicanceState();
}

class _DriverLicanceState extends State<DriverLicance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Make an Application',
      ),
      body: BasePadding(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sürücü Doğrulama',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: HexColor("#494949"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              Text(
                'Barkod  No. -  Motorlo Taşıt Sürücü Doğrulama',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: HexColor("#494949"),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(11),
              ),
              Text(
                "Barkod numarası E-Devletten alınır ve Sürücü Belgesi kontrolü için kullanılır.",
                style: context.textStyle.bodySmallMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              NameTextFormField(
                context: context,
                hintText: 'Barkod Numarası',
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              Text(
                'Barkod  No. -  Adli Sicil Kaydı Belgesi',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: HexColor("#494949"),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(11),
              ),
              Text(
                "Barkod numarası E-Devletten alınır.",
                style: context.textStyle.bodySmallMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              NameTextFormField(
                context: context,
                hintText: 'Barkod Numarası',
              ),
              SizedBox(
                height: context.responsiveHeight(200),
              ),
              PrimaryButton(
                context: context,
                text: "Make an Application",
                onPressed: () {},
              ),
            ],
          )),
    );
  }
}
