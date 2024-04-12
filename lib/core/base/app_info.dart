import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../init/models/caller_home_directions.dart';
import '../init/models/directions.dart';
import '../init/models/driver_home_directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  CallerHomeDirections? callerDropOffLocation;
  DriverHomeDirections? driverDropOffLocation;

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

  void driverDropOffLocationCache(DriverHomeDirections driverDropOff) async {
    driverDropOffLocation = driverDropOff;
    var box = await Hive.openBox('driver_directions');
    await box.put('driver_directions', driverDropOff.toJson());
  }
}
