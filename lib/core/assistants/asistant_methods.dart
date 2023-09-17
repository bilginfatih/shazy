import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shazy/core/assistants/request_assistant.dart';

import '../base/app_info.dart';
import '../init/model/directions.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyB_8L6k1f0T1wHaV6oI5l3vH6WLRzRScGM&components=country:TUR";
    print("asd2: " + apiUrl);

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }
}
