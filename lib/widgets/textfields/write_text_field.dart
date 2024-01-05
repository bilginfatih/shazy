import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class WriteTextField extends TextField {
  WriteTextField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
    required String hintText,
    required HexColor borderColor,
    required int maxLines,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: HexColor("#D0D0D0")),
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          maxLines: maxLines,
        );
}
