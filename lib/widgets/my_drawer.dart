import 'package:flutter/material.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/history_screen.dart';
import 'package:zomato_users/mainScreen/home_screen.dart';
import 'package:zomato_users/mainScreen/my_orders_screen.dart';

import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
              color: zomatocolor,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MyOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "History",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => SplashScreen()));
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
