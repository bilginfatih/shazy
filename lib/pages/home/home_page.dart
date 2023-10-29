import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/pages/history/history_upcoming_page.dart';
import 'package:shazy/pages/home/home_screen_transport.dart';
import 'package:shazy/pages/offer/offer_page.dart';
import 'package:shazy/pages/wallet/wallet_page.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = [
    HomeScreenTransport(),
    HistoryUpcomingPage(),
    const WalletPage(),
    const OfferPage(),
    const OfferPage(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
          unselectedItemColor: context.isLight
              ? AppThemes.contentSecondary
              : HexColor('#D0D0D0'),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
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

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String asset, String label, int index) {
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
}
