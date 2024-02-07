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
          _buildListItem(
              "changePassword".tr(), NavigationConstant.changePassword),
          _buildListItem(
              "changeLanguage".tr(), NavigationConstant.changeLanguage),
          _buildListItem(
              "privacyPolicy".tr(), NavigationConstant.privacyPolicy),
          _buildListItem("contactUs".tr(), NavigationConstant.contactUs),
          _buildListItem("deleteAccount".tr(), NavigationConstant.deleteAccount),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, path) {
    return BasePadding(
      context: context,
      child: SizedBox(
        height: context.responsiveHeight(51),
        width: context.responsiveWidth(351),
        child: InkWell(
          onTap: () {
            NavigationManager.instance.navigationToPage(path);
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
