import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../core/base/app_info.dart';
import '../../core/init/models/directions.dart';
import '../../core/init/models/predicted_places.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../core/init/network/network_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../dialogs/progress_dialog.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String apiUrl = "/google/placedetails/$placeId";
    var responsePlaceIdApi = await NetworkManager.instance.get(apiUrl);

    NavigationManager.instance.navigationToPop();

    if (responsePlaceIdApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    Directions directions = Directions();
    directions.endLocationName = responsePlaceIdApi["result"]["name"];
    directions.currentLocationName = responsePlaceIdApi["result"]["formatted_address"];
    directions.locationId = placeId;
    directions.endLocationLatitude = responsePlaceIdApi["result"]["geometry"]["location"]["lat"];
    directions.endLocationLongitude = responsePlaceIdApi["result"]["geometry"]["location"]["lng"];
    directions.currentLocationLatitude = cPosition.latitude;
    directions.currentLocationLongitude = cPosition.longitude;

    String urlOriginToDestinationDirectionDetails =
        "/google/directions/${cPosition.latitude}/${cPosition.longitude}/${directions.endLocationLatitude}/${directions.endLocationLongitude}";

    var responseDirectionApi = await NetworkManager.instance.get(urlOriginToDestinationDirectionDetails);

    directions.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    //directions.e_pointsDrive = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directions.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directions.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directions.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directions.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    directions.end_address = responseDirectionApi["routes"][0]["legs"][0]["end_address"];
    directions.start_address = responseDirectionApi["routes"][0]["legs"][0]["start_address"];

    int metreDistance = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    int totalPaymant = ((metreDistance / 1000) * 35).toInt();

    if (totalPaymant < 180) {
      totalPaymant = 180;
    }
    directions.totalPayment = totalPaymant.toString();

    Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

    NavigationManager.instance.navigationToPage(
      NavigationConstant.paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // Buton rengini kaldır
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: context.isLight ? Colors.black : Colors.white,
            ),
            SizedBox(
              width: context.responsiveWidth(14.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.responsiveHeight(8.0),
                  ),
                  Text(
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.subheadLargeMedium.copyWith(color: context.isLight ? HexColor("#5A5A5A") : Colors.white),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(2.0),
                  ),
                  Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.bodySmallRegular.copyWith(
                      color: HexColor("#B8B8B8"),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(8.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
