import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zomato_users/assistantMethods/assistant_methods.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
String? addressID;
double? totalAmount;
String? sellerID;

PlacedOrderScreen({
  this.sellerID,
  this.totalAmount,
  this.addressID,
});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {

  String orderID = DateTime.now().microsecondsSinceEpoch.toString();
  
  addOrderDetails() {
    writeOrderDetailsForUser({
      "addressID" : widget.addressID,
      "totalAmount" : widget.totalAmount,
      "orderBy" : sharedPreferences!.getString("uid"),
      "productIDs" : sharedPreferences!.getStringList("userCart"),
      "paymentDetails" : "Cash on Delivery",
      "orderTime": orderID,
      "isSuccess" : true,
      "sellerID" : widget.sellerID,
      "riderUID" : "",
      "status" : "normal",
      "orderID" : orderID,

    });

    writeOrderDetailsForSeller({
      "addressID" : widget.addressID,
      "totalAmount" : widget.totalAmount,
      "orderBy" : sharedPreferences!.getString("uid"),
      "productIDs" : sharedPreferences!.getStringList("userCart"),
      "paymentDetails" : "Cash on Delivery",
      "orderTime": orderID,
      "isSuccess" : true,
      "sellerID" : widget.sellerID,
      "riderUID" : "",
      "status" : "normal",
      "orderID" : orderID,
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderID ="";
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
        Fluttertoast.showToast(msg: "Order has been placed successfully.");
      });
    });
  }
  
  Future writeOrderDetailsForUser (Map<String, dynamic> data) async{
    await FirebaseFirestore.instance.collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderID)
        .set(data);
  }

  Future writeOrderDetailsForSeller (Map<String, dynamic> data) async{
    await FirebaseFirestore.instance.collection("orders")
        .doc(orderID)
        .set(data);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              addOrderDetails();
            },
            child: Text(
              "Place Order",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: zomatocolor,
            ),
          ),
        ),
      ),
    );
  }
}
