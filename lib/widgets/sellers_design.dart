import 'package:flutter/material.dart';
import 'package:zomato_users/mainScreen/menus_screen.dart';

import '../models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {
Sellers? model;
BuildContext? context;
SellersDesignWidget({super.key, this.model, this.context});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusScreen(model: widget.model,)));
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    child: Image.network(
                      widget.model!.sellerAvatarUrl!,
                      height: 220,
                      width: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                 // Grey shade overlay when the restaurant is closed
                  if(widget.model!.sellerRestaurantStatus == "off")
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                            BlendMode.multiply,),
                        child: Image.network(
                          widget.model!.sellerAvatarUrl!,
                          height: 220,
                          width: 1000,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),


                  if(widget.model!.sellerRestaurantStatus == "off")
                       Positioned.fill(child: Align(
                         alignment: Alignment.center,
                         child: Text("Restaurant is closed.",
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                         ),),
                       ))
                ],
              ),
              const SizedBox(height: 1.0,),
              Padding(padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text(widget.model!.sellerName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                  Text(widget.model!.sellerEmail!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),)
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
