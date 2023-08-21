import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            'assets/svg/map.svg',
          ),
        ),
        suffix: GestureDetector(
            onTap: () {
              setState(() {
                widget.controller.clear();
              });
            },
            child: SvgPicture.asset('assets/svg/cancel.svg')),
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
