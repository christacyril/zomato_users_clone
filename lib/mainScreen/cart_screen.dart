import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/assistantMethods/cart_item_counter.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/address_screen.dart';
import 'package:zomato_users/splashScreen/splash_screen.dart';
import 'package:zomato_users/widgets/cart_item_design.dart';
import 'package:zomato_users/widgets/progress_bar.dart';
import 'package:zomato_users/widgets/text_widget_header.dart';

import '../assistantMethods/assistant_methods.dart';
import '../assistantMethods/total_amount.dart';
import '../models/items.dart';

class CartScreen extends StatefulWidget {
  final String? sellerID;

  CartScreen({this.sellerID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantitiesList;

  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantitiesList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text(
          "Zomato Clone",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: () {
                clearCartNow(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SplashScreen()));
                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
              heroTag: "btn1",
              label: Text(
                "Clear Cart",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              backgroundColor: zomatocolor,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: () {
                //Addressscreen
                Navigator.push(context, MaterialPageRoute(builder: (c)=> AddressScreen(totalAmount: totalAmount.toDouble(), sellerID: widget.sellerID,)));
              },
              heroTag: "btn2",
              label: Text(
                "Check Out",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              icon: Icon(
                Icons.check_outlined,
                color: Colors.white,
              ),
              backgroundColor: zomatocolor,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List")),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("items").where(
                  "itemID", whereIn: separateItemIDs())
                  .orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                ) : snapshot.data!.docs.length == 0 ? Container()
                  : SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                  Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );

                  if(index== 0) {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price! * separateItemQuantitiesList![index]);
                  }else {
                    totalAmount = totalAmount + (model.price! * separateItemQuantitiesList![index]);
                  }
                  if(snapshot.data!.docs.length -1 == index){
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quantityNumber: separateItemQuantitiesList![index],
                  );
                },
                childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                ),
                );
              }
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c) {
              return Padding(padding: EdgeInsets.all(10),
              child: Center(
                child: cartProvider.count == 0 ?
                    Container() :
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total (incl. VAT)",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            ),


                            Text("Rs " + amountProvider.tAmount.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            ),
                          ],
                        )
                      ],
                    )
              ),
              );
            },),
          )
        ],
      ),
    );
  }
}
