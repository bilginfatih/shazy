import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  Padding _buildMapIcon(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          'assets/svg/map.svg',
          colorFilter: ColorFilter.mode(
              context.isLight ? Colors.black : Colors.white, BlendMode.srcIn),
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
                context.isLight ? Colors.black : Colors.white, BlendMode.srcIn),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: context.textStyle.subheadLargeMedium,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        prefixIcon: _buildMapIcon(context),
        suffix: _buildCancelButton(context),
        fillColor: context.isLight ? null : HexColor('#35383F'),
        filled: true,
        hintText: 'Search',
        hintStyle: context.textStyle.subheadLargeMedium.copyWith(
          color: AppThemes.hintTextNeutral,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppThemes.borderSideColor,
          ),
        ),
      ),
    );
  }
}
