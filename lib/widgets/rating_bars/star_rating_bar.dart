import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class StarRatingBar extends StatefulWidget {
  StarRatingBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<StarRatingBar> createState() => _StarRatingBarState();
}

class _StarRatingBarState extends State<StarRatingBar> {
  GestureDetector _buildStar(int index) => GestureDetector(
        onTap: () {
          setState(() {
            widget.selectedIndex = index;
          });
        },
        child: index <= widget.selectedIndex
            ? Icon(
                Icons.star,
                color: AppThemes.warningYellow700,
              )
            : const Icon(Icons.star_border_outlined),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.customWidth(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
    );
  }
}
