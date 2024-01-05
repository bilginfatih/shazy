import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';

class Language {
  final String flag;
  final String name;

  Language({required this.flag, required this.name});
}

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  List<Language> languages = [
    Language(flag: '🇬🇧', name: 'United Kingdom'),
    Language(flag: '🇮🇳', name: 'India'),
    Language(flag: '🇸🇦', name: 'Saudi Arabia'),
    Language(flag: '🇫🇷', name: 'France'),
    Language(flag: '🇩🇪', name: 'Germany'),
    Language(flag: '🇵🇹', name: 'Portugal'),
    Language(flag: '🇹🇷', name: 'Turkey'),
    Language(flag: '🇳🇱', name: 'Netherlands'),
  ];

  int selectedLanguageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Change Language',
      ),
      body: BasePadding(
        context: context,
        child: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            if (index == 7) {
              return Column(
                children: [
                  SizedBox(
                    height: context.responsiveHeight(16),
                  ),
                  PrimaryButton(
                    text: 'Save',
                    context: context,
                    onPressed: () {},
                  ),
                ],
              );
            }
            return _buildLanguageItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildLanguageItem(int index) {
    final language = languages[index];
    final isSelected = index == selectedLanguageIndex;

    return Container(
      height: context.responsiveHeight(64),
      width: context.responsiveWidth(362),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? HexColor("#9C54D5") : HexColor("#D0D0D0"),
        ),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            selectedLanguageIndex = index;
          });
        },
        leading: Text(
          language.flag,
          style: TextStyle(fontSize: 40),
        ),
        title: Text(
          language.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(language.name),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: AppThemes.lightPrimary500,
              )
            : Icon(Icons.check_circle_outline),
      ),
    );
  }
}
