import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:zomato_users/assistantMethods/assistant_methods.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/widgets/app_bar.dart';

import '../models/items.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemsDetailsScreen({super.key, this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  // deleteItem(String itemID) {
  //   FirebaseFirestore.instance
  //       .collection("sellers")
  //       .doc(sharedPreferences!.getString("uid"))
  //       .collection("menus")
  //       .doc(widget.model!.menuID)
  //       .collection("items")
  //       .doc(itemID)
  //       .delete()
  //       .then((value) {
  //     FirebaseFirestore.instance.collection("items").doc(itemID).delete();
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (c) => SplashScreen()));
  //     Fluttertoast.showToast(msg: "Item Deleted Successfully.");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        sellerUID: widget.model!.sellerID,
      ),
      body: ListView(
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.model!.title.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "from Rs " + widget.model!.price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.model!.longDescription.toString(),
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(18),
                    child: NumberInputPrefabbed.roundedButtons(
                        controller: counterTextEditingController,
                        incDecBgColor: zomatocolor!,
                        incIconColor: Colors.white,
                        decIconColor: Colors.white,
                        incIcon: Icons.add,
                        decIcon: Icons.remove,
                        numberFieldDecoration: InputDecoration(
                          border: InputBorder.none
                        ),
                      min: 1,
                      max: 9,
                      initialValue: 1,
                      buttonArrangement: ButtonArrangement.incRightDecLeft,
                    ),
                  )),

                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: (){
                          int itemCounter = int.parse(counterTextEditingController.text);

                          List<String> separateItemIDsList = separateItemIDs();

                          separateItemIDsList.contains(widget.model!.itemID)
                          ? Fluttertoast.showToast(msg: "Item is already in the cart.")
                              : addItemToCart(widget.model!.itemID, context, itemCounter);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: zomatocolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Add to cart",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Image.network(widget.model!.thumbnailUrl.toString()),
      //     Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 widget.model!.title.toString(),
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //               ),
      //               Text(
      //                 "Rs " + widget.model!.price.toString(),
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //               )
      //             ],
      //           ),
      //           Text(
      //             widget.model!.longDescription.toString(),
      //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      //           ),
      //           SizedBox(
      //             height: 15,
      //           ),
      //           Center(
      //             child: GestureDetector(
      //               onTap: () {
      //               //  deleteItem(widget.model!.itemID!);
      //               },
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   color: zomatocolor,
      //                 ),
      //                 width: MediaQuery.of(context).size.width - 13,
      //                 height: 50,
      //                 child: Center(
      //                   child: Text(
      //                     "Delete this item.",
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 15,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
