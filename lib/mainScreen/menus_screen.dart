import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zomato_users/assistantMethods/assistant_methods.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/splashScreen/splash_screen.dart';
import 'package:zomato_users/widgets/progress_bar.dart';
import 'package:zomato_users/widgets/text_widget_header.dart';

import '../models/menus.dart';
import '../models/sellers.dart';
import '../widgets/menus_design.dart';


class MenusScreen extends StatefulWidget {
final Sellers? model;
MenusScreen({this.model});



  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text(
          "Zomato Clone",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            clearCartNow(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: widget.model!.sellerName!.toString() + " Menus"
            ),
          ),
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection("sellers").doc(widget.model!.sellerUID).collection("menus")
            .orderBy("publishedDate", descending: true).snapshots(),
          builder: (context, snapshot) {
          return !snapshot.hasData
              ? SliverToBoxAdapter(
            child: Center(child: circularProgress(),),
          ) : SliverStaggeredGrid.countBuilder(
              crossAxisCount: 1,
              staggeredTileBuilder: (c) => StaggeredTile.fit(1),
              itemBuilder: (context, index) {
                Menus model = Menus.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                );
                return MenusDesignWidget(
                  model: model,
                  context: context,
                );
              },
              itemCount: snapshot.data!.docs.length,
          );
          },
    )
        ],
      ),
    );
  }
}
