import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/global/global.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
String? title;
TextWidgetHeader({this.title});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {


    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: zomatocolor,
        ),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showToast(bool value){

  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
