import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/pages/home/driver_home/driver_home_page.dart';
import 'package:shazy/widgets/app_bars/custom_app_bar.dart';

import '../../core/init/cache/cache_manager.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/drawer/custom_drawer.dart';
import '../authentication/splash_page.dart';
import '../history/history_upcoming_page.dart';
import '../offer/offer_page.dart';
import '../profile/profile_page.dart';
import '../wallet/wallet_page.dart';
import 'home_screen_transport.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List _pages = [];
  String _name = '';
  String _email = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pages = [
      HomeScreenTransport(scaffoldKey: _scaffoldKey),
      HistoryUpcomingPage(scaffoldKey: _scaffoldKey),
      WalletPage(scaffoldKey: _scaffoldKey),
      OfferPage(scaffoldKey: _scaffoldKey),
      ProfilePage(scaffoldKey: _scaffoldKey),
    ];
    _getUserData();
    super.initState();
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(String asset, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        height: context.responsiveHeight(24),
        'assets/svg/$asset.svg',
        colorFilter: index == _currentIndex
            ? ColorFilter.mode(AppThemes.lightPrimary500, BlendMode.srcIn)
            : context.isLight
                ? null
                : ColorFilter.mode(HexColor('#D0D0D0'), BlendMode.srcIn),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? isDriver = ModalRoute.of(context)?.settings.arguments as bool?;
    if (isDriver != null && isDriver) {
      _pages[0] = const DriverHomePage();
      setState(() {});
    } else if (SplashPage.driverHomeDirections.driver_id != null) {
      _pages[0] = const DriverHomePage();
      setState(() {});
    }
    return Scaffold(
      key: _scaffoldKey,
      body: _pages[_currentIndex],
      drawer: CustomDrawer(
        context: context,
        email: _email,
        name: _name,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppThemes.lightPrimary500,
          unselectedItemColor: context.isLight ? AppThemes.contentSecondary : HexColor('#D0D0D0'),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (HomeScreenTransport.allowNavigation) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: <BottomNavigationBarItem>[
            _buildBottomNavigationBarItem('house', 'Home', 0),
            _buildBottomNavigationBarItem('history', 'History', 1),
            _buildBottomNavigationBarItem('wallet', 'Wallet', 2),
            _buildBottomNavigationBarItem('discount', 'Offer', 3),
            _buildBottomNavigationBarItem('user', 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserData() async {
    _name = await CacheManager.instance.getData('user', 'name');
    _email = await CacheManager.instance.getData('user', 'email');
    setState(() {});
  }
}
