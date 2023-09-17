import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../core/assistants/request_assistant.dart';
import '../../core/init/model/predicted_places.dart';
import '../../utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=AIzaSyB_8L6k1f0T1wHaV6oI5l3vH6WLRzRScGM&components=country:TUR";
      print(urlAutoCompleteSearch);
      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

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
            widget.controller.clear();
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
      onChanged: (valueTyped) {
        findPlaceAutoCompleteSearch(valueTyped);
      },
    );
  }
}
