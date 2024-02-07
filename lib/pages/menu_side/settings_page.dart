import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'settings'.tr(),
      ),
      body: ListView(
        children: [
          _buildListItem("changePassword".tr(),
              path: ''),
          _buildListItem("changeLanguage".tr(), path: NavigationConstant.changeLanguage),
          _buildListItem("privacyPolicy".tr(), path: ''),
          _buildListItem("contactUs".tr(), path: ''),
          _buildListItem("deleteAccount".tr(), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, {String? path, VoidCallback? onTap}) {
    return BasePadding(
      context: context,
      child: SizedBox(
        height: context.responsiveHeight(51),
        width: context.responsiveWidth(351),
        child: InkWell(
          onTap: () {
            if (path != null) {
              NavigationManager.instance.navigationToPage(path);
            } else if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: HexColor("#9C54D5"),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
