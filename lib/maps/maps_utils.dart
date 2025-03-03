import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> openMapWithPosition(double latitude, double longitude) async{
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if(await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else{
      throw "Could not open the map.";
    }
  }
}