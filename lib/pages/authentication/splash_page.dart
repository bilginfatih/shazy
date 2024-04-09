import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/services/user/user_identity_service.dart';
import '../../utils/extensions/context_extension.dart';

import '../../core/init/cache/cache_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/theme/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    String? email = await CacheManager.instance.getData('user', 'email');
    String? password = await CacheManager.instance.getData('user', 'password');
    if (email == null || password == null) {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.welcome);
    }
    UserModel model = UserModel(email: email, password: password);
    String? data = await UserService.instance.login(model);
    await _setLang();
    if (data != null) {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.welcome);
    } else {
      await UserIdentityService.instance.cacheUserIdentity();
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
    }
  }

  Future<void> _setLang() async {
    String? lang = await CacheManager.instance.getData('user', 'lang');
    if (lang != null && lang != 'en' && mounted) {
      await context.setLocale(Locale(lang));
      await SessionManager().set('lang', lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.lightPrimary500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: context.responsiveWidth(140),
              height: context.responsiveHeight(140),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: Image.asset(
                "assets/png/main_logo.png",
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(7),
            ),
            Text(
              'Shazy',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
