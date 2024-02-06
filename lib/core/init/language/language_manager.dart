import 'package:flutter/material.dart';

class LanguageManager {
  LanguageManager._init();

  static LanguageManager instance = LanguageManager._init();

  final enLocale = const Locale('en');
  final trLocale = const Locale('tr');

  List<Locale> get supportedLocales => [enLocale, trLocale];
}
