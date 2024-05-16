import 'package:flutter/material.dart';
import 'package:zomato_users/global/global.dart';


circularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        zomatocolor,
      ),
    ),
  );
}