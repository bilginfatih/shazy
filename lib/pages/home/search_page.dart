import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/list_tile/search_list_tile.dart';
import '../../widgets/textfields/search_text_form_field.dart';

import '../../widgets/padding/base_padding.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Expanded _buildListView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: false,
          itemCount: 20,
          itemBuilder: (_, index) {
            return SearchListTile(
              text1: 'Burger Shop',
              text2: '2972 Westheimer Rd. Santa Ana, Illinois 85486',
              text3: '2.7km',
              context: context,
            );
          }),
    );
  }

  Row _buildResultText(BuildContext context) => Row(
        children: [
          Text(
            'Results for',
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor(context.isLight ? '#5A5A5A' : '#D0D0D0'),
            ),
          ),
          Text(
            ' "Shop"',
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor('#45847B'),
            ),
          ),
          const Spacer(),
          Text(
            '7 found',
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor('#45847B'),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            SizedBox(height: context.responsiveHeight(52)),
            SizedBox(
                height: context.responsiveHeight(60),
                child: SearchTextFormField(controller: _searchController)),
            SizedBox(height: context.responsiveHeight(19)),
            _buildResultText(context),
            SizedBox(height: context.responsiveHeight(21)),
            _buildListView(context),
          ],
        ),
      ),
    );
  }
}
