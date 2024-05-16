
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/assistantMethods/address_changer.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/save_address_screen.dart';
import 'package:zomato_users/widgets/address_design.dart';
import 'package:zomato_users/widgets/progress_bar.dart';
import 'package:zomato_users/widgets/simple_app_bar.dart';

import '../models/address.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerID;

  AddressScreen({this.totalAmount, this.sellerID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Zomato Clone",
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Address", style: TextStyle(
            color: Colors.white
          ),),
      backgroundColor: zomatocolor,
        icon:  Icon(Icons.add_location,
        color: Colors.white,
        ),
        onPressed: (){
            //save address screen
          Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScreen()));
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Select Address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
          ),
          Consumer<AddressChanger> (builder: (context, address, c){
            return Expanded(child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("userAddress")
              .snapshots(),
              builder: (context, snapshot){
                return !snapshot.hasData
                    ? Center(child: circularProgress(),)
                    : snapshot.data!.docs.length == 0
                    ? Container()
                    : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return AddressDesign(
                      currentIndex: address.count,
                      value: index,
                      addressID: snapshot.data!.docs[index].id,
                      totalAmount: widget.totalAmount,
                      sellerID: widget.sellerID,
                      model: Address.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>
                      ),
                    );
                  }
                );
              },
            ));
          })
        ],
      ),
    );
  }
}
