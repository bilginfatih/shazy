import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField(
      {super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  Padding _buildMapIcon(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          'assets/svg/map.svg',
          colorFilter: ColorFilter.mode(
              context.isLight ? Colors.black : HexColor('#E8E8E8'),
              BlendMode.srcIn),
        ),
      );

  GestureDetector _buildCancelButton(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            widget.controller.clear();
          });
        },
        child: Padding(
          padding: EdgeInsets.only(top: context.responsiveHeight(12)),
          child: SvgPicture.asset(
            'assets/svg/cancel.svg',
            colorFilter: ColorFilter.mode(
                context.isLight ? Colors.black : HexColor('#E8E8E8'),
                BlendMode.srcIn),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
      style: context.textStyle.subheadLargeMedium,
      textCapitalization: TextCapitalization.sentences,
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      decoration: InputDecoration(
        prefixIcon: _buildMapIcon(context),
        suffix: _buildCancelButton(context),
        fillColor: context.isLight ? null : HexColor('#35383F'),
        filled: true,
        hintText: 'Search',
        hintStyle: context.textStyle.subheadLargeMedium.copyWith(
          color: AppThemes.hintTextNeutral,
        ),
        focusedBorder: context.isLight
            ? null
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppThemes.lightPrimary500,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppThemes.borderSideColor,
          ),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
