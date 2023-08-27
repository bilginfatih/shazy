import 'package:flutter/material.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/extensions/string_extension.dart';

import '../../utils/theme/themes.dart';

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isObscure;
  final BuildContext context;

  PasswordTextFormField({
    Key? key,
    this.controller,
    required this.hintText,
    this.isObscure = true,
    required this.context,
  }) : super(key: key);

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: _isObscure ? const Icon(Icons.visibility_off_outlined) : const Icon(Icons.visibility_outlined),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        hintText: widget.hintText,
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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Parola boş olamaz.';
        } else if (!value.isValidPassword) {
          return 'Geçerli bir parola giriniz.';
        }
        return null;
      },
    );
  }
}
