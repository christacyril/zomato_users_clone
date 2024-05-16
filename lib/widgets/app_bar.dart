import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomato_users/assistantMethods/cart_item_counter.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/cart_screen.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? sellerUID;
  final PreferredSizeWidget? bottom;

  MyAppBar({this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: zomatocolor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text("Zomato Clone",
      style: TextStyle(
        color: Colors.white
      ),),
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: (){
                  if(Provider.of<CartItemCounter>(context, listen: false).cartListItemCounter == 0) {
                    Fluttertoast.showToast(msg: "Cart is empty");
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (c) =>
                        CartScreen(sellerID: widget.sellerUID,)));
                  } //cartScreen
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                )
            ),
            Positioned(child: Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 20,
                  color: Colors.white,
                ),
                Positioned(
                  top: 3,
                  right: 4,
                  child: Center(
                    child: Consumer<CartItemCounter> (
                      builder: (context, counter, c){
                        return Text(
                          counter.count.toString(),
                          style: TextStyle(
                            color: zomatocolor,
                            fontSize: 12
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ))
          ],
        )
      ],
    );
  }
}
