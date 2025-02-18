import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'aboutUs'.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 14, 20),
        child: Text(
          'Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek. Bu kısım hakkında sayfasının içeriğidir. Metin buraya gelecek.',
          style: context.textStyle.bodyMediumRegular.copyWith(
            color: HexColor(context.isLight ? '#5A5A5A' : '#B8B8B8'),
          ), // İstediğiniz metin boyutunu ayarlayabilirsiniz.
        ),
      ),
    );
  }
}
