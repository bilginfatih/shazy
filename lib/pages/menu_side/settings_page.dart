import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/padding/base_padding.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Settings',
      ),
      body: ListView(
        children: [
          _buildListItem("Change Password", () {}),
          _buildListItem("Change Language", () {}),
          _buildListItem("Privacy Policy", () {}),
          _buildListItem("Contact Us", () {}),
          _buildListItem("Delete Account", () {}),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, VoidCallback onTap) {
    return BasePadding(
      context: context,
      child: SizedBox(
        height: context.responsiveHeight(51),
        width: context.responsiveWidth(351),
        child: InkWell(
          onTap: onTap,
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
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
