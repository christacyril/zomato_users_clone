import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/assistantMethods/address_changer.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/placed_order_screen.dart';
import 'package:zomato_users/maps/maps_utils.dart';
import 'package:zomato_users/splashScreen/splash_screen.dart';

import '../models/address.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerID;

  AddressDesign({
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerID,
  });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Select this Address
        Provider.of<AddressChanger>(context, listen: false).displayResult(
            widget.value);
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3)
              )
              ]
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                        value: widget.value!,
                        groupValue: widget.currentIndex!,
                        activeColor: zomatocolor,
                        onChanged: (value) {
                          Provider.of<AddressChanger>(context, listen: false)
                              .displayResult(value);
                        }
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: " + widget.model!.name.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Phone: " + widget.model!.phoneNumber.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Flat: " + widget.model!.flatNumber.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "City: " + widget.model!.city.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "State: " + widget.model!.state.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Full Address: " + widget.model!.completeAddress
                              .toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                        //Check on Map
                          MapsUtils.openMapWithPosition(widget.model!.lat!,
                              widget.model!.lng!);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.map, color: zomatocolor,),
                            SizedBox(width: 10,),
                            Text("Check on Map", style: TextStyle(
                                color: zomatocolor
                            ),)
                          ],
                        )),

                    SizedBox(width: 10,),
                    widget.value == Provider
                        .of<AddressChanger>(context)
                        .count
                        ? ElevatedButton(
                        onPressed: () {
                      if(sharedPreferences!.getStringList("userCart")!.length - 1 != 0 ) {
                        //PlaceOrderScreen
                        if(sharedPreferences!.getStringList("userCart")!.length - 1 != 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>PlacedOrderScreen(
                            addressID: widget.addressID,
                            totalAmount: widget.totalAmount,
                            sellerID: widget.sellerID,
                          )));
                        }
                      }
                      else {
                        Fluttertoast.showToast(msg: "Cart is empty");
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
                      }
                        },
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                    style:ElevatedButton.styleFrom(
                      backgroundColor: zomatocolor
                    )
                    ) : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
