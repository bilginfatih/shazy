import 'package:flutter/material.dart';
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
    String email = await CacheManager.instance.getData('user', 'email');
    String password = await CacheManager.instance.getData('user', 'password');
    UserModel model = UserModel(email: email, password: password);
    String? data = await UserService.instance.login(model);
    if (data != null) {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.welcome);
    } else {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
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
              width: context.responsiveWidth(125),
              height: context.responsiveHeight(120),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
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