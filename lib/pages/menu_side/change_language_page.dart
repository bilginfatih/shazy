import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/cache/cache_manager.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';

class Language {
  final String flag;
  final String name;
  final String code;

  Language({required this.flag, required this.name, required this.code});
}

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  final List<Language> _languages = [
    Language(flag: '🇬🇧', name: 'United Kingdom', code: 'en'),
    Language(flag: '🇮🇳', name: 'India', code: 'hi'),
    Language(flag: '🇸🇦', name: 'Saudi Arabia', code: 'ar'),
    Language(flag: '🇫🇷', name: 'France', code: 'fr'),
    Language(flag: '🇩🇪', name: 'Germany', code: 'de'),
    Language(flag: '🇵🇹', name: 'Portugal', code: 'pt'),
    Language(flag: '🇹🇷', name: 'Turkey', code: 'tr'),
    Language(flag: '🇳🇱', name: 'Netherlands', code: 'nl'),
  ];

  int _selectedLanguageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'changeLanguage'.tr(),
      ),
      body: _buildBody(context),
    );
  }

  BasePadding _buildBody(BuildContext context) {
    return BasePadding(
      context: context,
      child: Column(
        children: [
          _buildListView(),
          _buildButton(context),
        ],
      ),
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          return _buildLanguageItem(index);
        },
      ),
    );
  }

  PrimaryButton _buildButton(BuildContext context) {
    return PrimaryButton(
      text: 'save'.tr(),
      context: context,
      onPressed: _setLang,
    );
  }

  Future<void> _setLang() async {
    String lang = _languages[_selectedLanguageIndex].code;
    await CacheManager.instance.putData('user', 'lang', lang);
    if (mounted) {
      await context.setLocale(Locale(lang));
    }
    await SessionManager().set('lang', lang);
    NavigationManager.instance.navigationToPop();
  }

  Widget _buildLanguageItem(int index) {
    final language = _languages[index];
    final isSelected = index == _selectedLanguageIndex;

    return Container(
      height: context.responsiveHeight(64),
      width: context.responsiveWidth(362),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? HexColor("#9C54D5") : HexColor("#D0D0D0"),
        ),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedLanguageIndex = index;
          });
        },
        leading: Text(
          language.flag,
          style: const TextStyle(fontSize: 40),
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
            : const Icon(
                Icons.check_circle_outline,
                color: Colors.black38,
              ),
      ),
    );
  }
}
