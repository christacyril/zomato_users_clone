import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/models/address.dart';
import 'package:zomato_users/widgets/progress_bar.dart';
import 'package:zomato_users/widgets/shipment_address_design.dart';
import 'package:zomato_users/widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  String? orderID;

  OrderDetailsScreen({
    this.orderID,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text(
          "Zomato Clone",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (context, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Order ID = " + widget.orderID!,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Order at: " +
                                  DateFormat("dd MMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"])))),

                              SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Total Price: Rs " + dataMap["totalAmount"].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              orderStatus == "ended"
                              ? Text("Order Received", style: TextStyle(color: zomatocolor, fontWeight: FontWeight.bold, fontSize: 30),)
                                  : Text("Order Processing", style: TextStyle(color: zomatocolor, fontWeight: FontWeight.bold, fontSize: 30),),
                              FutureBuilder(
                              future: FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString("uid"))
                                  .collection("userAddress").doc(dataMap["addressID"]).get(),
                                  builder: (context, snapshot){
                                return snapshot.hasData
                                    ? ShipmentAddressDesign(
                                  model: Address.fromJson(
                                    snapshot.data!.data()! as Map<String, dynamic>
                                  ),
                                )
                                    : Center(child: circularProgress(),);
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
