import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/textfields/search_text_form_field.dart';

import '../../widgets/padding/base_padding.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            SizedBox(height: context.responsiveHeight(52)),
            SearchTextFormField(controller: _searchController),
            SizedBox(height: context.responsiveHeight(16)),
            
          ],
        ),
      ),
    );
  }
}
