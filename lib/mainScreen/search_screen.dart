import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/widgets/sellers_design.dart';

import '../models/sellers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? restaurantsDocumentsList;
  String sellerName = "";

  initSearchRestaurant(String textEntered) {
    restaurantsDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: TextField(
          onChanged: (value) {
            setState(() {
              sellerName = value;
            });
            initSearchRestaurant(value);
          },
          decoration: InputDecoration(
              hintText: "Search Restaurant here...",
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  initSearchRestaurant(sellerName);
                },
              )),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,

          ),
        ),
      ),
      body: FutureBuilder(
        future: restaurantsDocumentsList,
        builder: (context, snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                Sellers model = Sellers.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>
                );

                return SellersDesignWidget(
                  model: model,
                  context: context,
                );
              }) : Center(child: Text("No records found."),);
        },
      ),
    );
  }
}
