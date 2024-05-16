import 'package:flutter/material.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/splashScreen/splash_screen.dart';

import '../models/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  Address? model;

  ShipmentAddressDesign({
    this.model,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(10),
        child: Text("Shipping Details:",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ),),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  Text("Name: "),
                  Text(model!.name!),
                ]
              ),
              TableRow(
                  children: [
                    Text("Phone: "),
                    Text(model!.phoneNumber!),
                  ]
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
        Padding(padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Address: " +model!.completeAddress!),

            Center(
              child: ElevatedButton(
                onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
                },
                child: Text("Go Back",
                style: TextStyle(
                  color: Colors.white
                ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: zomatocolor
                ),
              ),
            )
          ],
        ),)
      ],
    );
  }
}
