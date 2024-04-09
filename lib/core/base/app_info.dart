import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../init/models/caller_home_directions.dart';
import '../init/models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  CallerHomeDirections? callerDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) async {
    userDropOffLocation = dropOffAddress;
    var box = await Hive.openBox('directions');
    await box.put('directions', dropOffAddress.toJson());
    notifyListeners();
  }

  void callerDropOffLocationCache(CallerHomeDirections callerDropOff) async {
    callerDropOffLocation = callerDropOff;
    var box = await Hive.openBox('caller_directions');
    await box.put('caller_directions', callerDropOff.toJson());
    notifyListeners();
  }
}
