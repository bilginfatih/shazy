import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../core/init/models/predicted_places.dart';
import '../../core/init/network/network_manager.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/list_tile/place_prediction_tile.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/search_text_form_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch = '/google/autocomplete/$inputText';

      var responseAutoCompleteSearch = await NetworkManager.instance.get(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  late final TextEditingController _searchController = TextEditingController();
  Expanded _buildListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: false,
        itemCount: placesPredictedList.length,
        itemBuilder: (_, index) {
          return PlacePredictionTileDesign(
            predictedPlaces: placesPredictedList[index],
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 2,
            color: Colors.transparent,
            thickness: 1,
          );
        },
      ),
    );
  }

  Row _buildResultText(BuildContext context) => Row(
        children: [
          Text(
            'resultsFor'.tr(),
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor(context.isLight ? '#5A5A5A' : '#D0D0D0'),
            ),
          ),
          Text(
            ' "${_searchController.text}"',
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor('#45847B'),
            ),
          ),
          const Spacer(),
          Text(
            '${placesPredictedList.length} found',
            style: context.textStyle.subheadLargeSemibold.copyWith(
              color: HexColor('#45847B'),
            ),
          ),
        ],
      );

  Padding _buildMapIcon(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          'assets/svg/map.svg',
          colorFilter: ColorFilter.mode(context.isLight ? Colors.black : HexColor('#E8E8E8'), BlendMode.srcIn),
        ),
      );

  GestureDetector _buildCancelButton(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _searchController.clear();
            placesPredictedList.clear();
          });
        },
        child: Padding(
          padding: EdgeInsets.only(top: context.responsiveHeight(12)),
          child: SvgPicture.asset(
            'assets/svg/cancel.svg',
            colorFilter: ColorFilter.mode(context.isLight ? Colors.black : HexColor('#E8E8E8'), BlendMode.srcIn),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            SizedBox(
                height: context.responsiveHeight(60),
                child: SearchTextFormField(
                  controller: _searchController,
                  onChanged: (p0) {
                    findPlaceAutoCompleteSearch(p0);
                  },
                )),
            SizedBox(height: context.responsiveHeight(19)),
            _buildResultText(context),
            _buildListView(context),
          ],
        ),
      ),
    );
  }
}
