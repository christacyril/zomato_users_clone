import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/infoHandler/app_info.dart';

import '../models/directions.dart';

class PrecisePickupLocationScreen extends StatefulWidget {
  const PrecisePickupLocationScreen({super.key});

  @override
  State<PrecisePickupLocationScreen> createState() =>
      _PrecisePickupLocationScreenState();
}

class _PrecisePickupLocationScreenState
    extends State<PrecisePickupLocationScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottomPaddingOfMap = 0;
  List<Placemark>? placemarks;

  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  locateUserPosition() async {
    Position cposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cposition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    placemarks = await placemarkFromCoordinates(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    Placemark pMark = placemarks![0];
    String fullAddress =
        "${pMark.subThoroughfare} ${pMark.subThoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}";

    _flatNumber.text =
        "${pMark.subThoroughfare} ${pMark.subThoroughfare}, ${pMark.subLocality} ${pMark.locality}";
    _city.text =
        "${pMark.subAdministrativeArea} ${pMark.administrativeArea}, ${pMark.postalCode}";
    _state.text = "${pMark.country}";
    _completeAddress.text = fullAddress;
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: "AIzaSyBly7FMffHg_jrYCgjDx4rv4yJSC8ty2cM");
      setState(() async {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);

        placemarks = await placemarkFromCoordinates(
            pickLocation!.latitude, pickLocation!.longitude);

        if (placemarks != null && placemarks!.isNotEmpty) {
          Placemark pMark = placemarks![0];
          String fullAddress =
              "${pMark.subThoroughfare} ${pMark.subThoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}";

          _flatNumber.text =
              "${pMark.subThoroughfare} ${pMark.subThoroughfare}, ${pMark.subLocality} ${pMark.locality}";
          _city.text =
              "${pMark.subAdministrativeArea} ${pMark.administrativeArea}, ${pMark.postalCode}";
          _state.text = "${pMark.country}";
          _completeAddress.text = fullAddress;
          _latitude.text = pickLocation!.latitude.toString();
          _longitude.text = pickLocation!.longitude.toString();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 100, bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 50;
              });
              locateUserPosition();
            },
            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 60, bottom: bottomPaddingOfMap),
              child: Image.asset(
                "images/pick.png",
                height: 45,
                width: 45,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: zomatocolor!),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? (Provider.of<AppInfo>(context)
                                .userPickUpLocation!
                                .locationName!)
                            .substring(0, 24) +
                        "..."
                    : "Not Getting Address",
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: zomatocolor),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Map<String, TextEditingController> result = {
                    "flatNumber": _flatNumber,
                    "city": _city,
                    "state": _state,
                    "completeAddress": _completeAddress,
                    "latitude": _latitude,
                    "longitude": _longitude,
                  };

                  Navigator.pop(context, result);
                },
                child: Text(
                  "Set Current Location.",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: zomatocolor,
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
