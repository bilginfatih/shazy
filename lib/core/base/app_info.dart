import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../init/models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation, userDropOffLocation2;

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
}
