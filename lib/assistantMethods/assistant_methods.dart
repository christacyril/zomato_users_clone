
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/assistantMethods/cart_item_counter.dart';
import 'package:zomato_users/global/global.dart';

separateOrderItemsIDs(orderIDs) {
  List<String> separateOrderItemIDsList = [],
      defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    String getItemID = (pos != -1) ? item.substring(0, pos) : item;

    separateOrderItemIDsList.add(getItemID);
  }

  return separateOrderItemIDsList;
}

separateItemIDs() {
  List<String> separateItemIDsList = [],
      defaultItemList = [];
  int i = 0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    String getItemID = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIDsList.add(getItemID);
  }

  return separateItemIDsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart")!;
  tempList!.add(foodItemId! + ":$itemCounter");

  FirebaseFirestore.instance.collection("users").doc(
      firebaseAuth.currentUser!.uid).update(
      {
        "userCart": tempList,
      }).then((value) {
    Fluttertoast.showToast(msg: "Item Added Successfully.");
    sharedPreferences!.setStringList("userCart", tempList);

    //update the CartItemCounter
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

separateOrderItemQuantities(orderIDs) {
  List<String> separateOrderQuantitiesList = [],
      defaultItemList = [];
  int i = 1;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());
    separateOrderQuantitiesList.add(quantityNumber.toString());
  }

  return separateOrderQuantitiesList;
}

separateItemQuantities() {
  List<int> separateItemQuantitiesList = [];
  List<String> defaultItemList = [];
  int i = 1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());
    separateItemQuantitiesList.add(quantityNumber);
  }

  return separateItemQuantitiesList;
}

clearCartNow(context) {
  sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance.collection("users").doc(
      firebaseAuth.currentUser!.uid).update(
      {
        "userCart": emptyList
      }).then((value){
        sharedPreferences!.setStringList("userCart", emptyList!);
        Provider.of<CartItemCounter> (context, listen: false).displayCartListItemsNumber();
  });
}
