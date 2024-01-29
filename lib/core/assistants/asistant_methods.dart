import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../base/app_info.dart';
import '../init/models/direction_details_info.dart';
import '../init/models/directions.dart';
import '../init/network/network_manager.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {
    try {
      String apiUrl = "/google/geocode/${position.latitude}/${position.longitude}";

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      if (requestResponse != null) {
        String humanReadableAddress = requestResponse["results"][0]["formatted_address"];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = position.latitude;
        userPickUpAddress.locationLongitude = position.longitude;
        userPickUpAddress.locationName = humanReadableAddress;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

        return humanReadableAddress;
      } else {
        // Handle the case where the response is null or not as expected
        return "Error Occurred, Failed. No Response.";
      }
    } catch (e) {
      // Handle exceptions or errors here
      print(e);
      return "Error Occurred, Failed. Exception.";
    }
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng origionPosition, LatLng destinationPosition) async {
  try {
    String urlOriginToDestinationDirectionDetails = "/google/directions/${origionPosition.latitude}/${origionPosition.longitude}/${destinationPosition.latitude}/${destinationPosition.longitude}";

    var responseDirectionApi = await NetworkManager.instance.get(urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == null) {
      // Handle the case where the response is null
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.e_pointsDrive = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];
    
    directionDetailsInfo.end_address = responseDirectionApi["routes"][0]["legs"][0]["end_address"];
    directionDetailsInfo.start_address = responseDirectionApi["routes"][0]["legs"][0]["start_address"];
    

    return directionDetailsInfo;
  } catch (e) {
    // Handle exceptions or errors here
    print(e);
    return null;
  }
}

}
