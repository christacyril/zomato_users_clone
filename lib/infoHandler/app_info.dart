
import 'package:flutter/cupertino.dart';
import 'package:zomato_users/models/directions.dart';

class AppInfo extends ChangeNotifier{

  Directions? userPickUpLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

}