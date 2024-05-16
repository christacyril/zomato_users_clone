import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zomato_users/mainScreen/precise_pickup_location.dart';
import 'package:zomato_users/widgets/simple_app_bar.dart';
import 'package:zomato_users/widgets/text_field.dart';

import '../global/global.dart';
import '../models/address.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<Placemark>? placemarks;
  Position? position;
  Map<String, TextEditingController> locationResult = {};

  Future<void> _showPreciseAddressDialog(BuildContext context) async{
    Map<String, TextEditingController>? result = await showDialog<Map<String, TextEditingController>>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: PrecisePickupLocationScreen(),
          );
        });

    if(result != null) {
      setState(() {
        locationResult = result;
      });
    }
  }
  
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //  
  //  
  //   _name.text = sharedPreferences!.getString("name")!;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Zomato Clone",
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Save",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: zomatocolor,
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {
          
          if(formKey.currentState!.validate()){
            final model = Address(
              name: _name.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              city:  locationResult["city"]!.text,
              state: locationResult["state"]!.text,
              flatNumber: locationResult["flatNumber"]!.text,
              completeAddress: locationResult["completeAddress"]!.text,
              lat:double.parse(locationResult["latitude"]!.text) ,
              lng: double.parse(locationResult["longitude"]!.text),
            ).toJson();
            
            FirebaseFirestore.instance.collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("userAddress")
            .doc(DateTime.now().microsecondsSinceEpoch.toString())
            .set(model).then((value) {
              Fluttertoast.showToast(msg: "New Address has been saved.");
              formKey.currentState!.reset();
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 6,
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Save New Address",
                  style: TextStyle(
                      color: zomatocolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showPreciseAddressDialog(context);
              },
              icon: Icon(
                Icons.add_location,
                color: Colors.white,
              ),
              label: Text(
                "Select Location",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: zomatocolor),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),

                  MyTextField(
                    hint: "City",
                    controller: locationResult["city"] == null ? null : locationResult["city"],
                  ),
                  MyTextField(
                    hint: "State",
                    controller: locationResult["state"] == null ? null : locationResult["state"],
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: locationResult["flatNumber"] == null ? null : locationResult["flatNumber"],
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: locationResult["completeAddress"] == null ? null : locationResult["completeAddress"],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
