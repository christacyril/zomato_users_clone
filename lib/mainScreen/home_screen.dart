import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:zomato_users/global/global.dart';
import 'package:zomato_users/mainScreen/address_screen.dart';
import 'package:zomato_users/mainScreen/search_screen.dart';
import 'package:zomato_users/models/sellers.dart';
import 'package:zomato_users/splashScreen/splash_screen.dart';
import 'package:zomato_users/widgets/my_drawer.dart';
import 'package:zomato_users/widgets/progress_bar.dart';
import 'package:zomato_users/widgets/sellers_design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text(
          "Zomato",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {
                //Address screen

                Navigator.push(context, MaterialPageRoute(builder: (c)=> AddressScreen()));

              },
                icon: Icon(Icons.add_location),
              ),


              IconButton(onPressed: () {
                //Search Screen
                Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchScreen()));
              },
                icon: Icon(Icons.search),)
            ],
          )
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.3,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: ImageSlideshow(
                autoPlayInterval: 5000,
                isLoop: true,
                indicatorColor: zomatocolor,
                indicatorBackgroundColor: Colors.white,
                indicatorRadius: 5,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.3,
                children: [
                  Image.asset("images/food1.jpg",
                    fit: BoxFit.cover,),
                  Image.asset("images/food2.jpg",
                    fit: BoxFit.cover,),
                  Image.asset("images/food3.jpg",
                    fit: BoxFit.cover,),
                  Image.asset("images/food4.jpg",
                    fit: BoxFit.cover,),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Restaurants",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("sellers")
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData ?
                SliverToBoxAdapter(
                  child: Center(
                      child: circularProgress()
                  ),
                ):
                    SliverToBoxAdapter(
                      child: SizedBox(height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          Sellers model = Sellers.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                          );

                          return SellersDesignWidget(
                            model: model,
                            context: context,
                          );
                        },
                      ),),
                    );
              }
          ),
        ],
      ),
    );
  }
}
