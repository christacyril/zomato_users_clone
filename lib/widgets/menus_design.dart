import 'package:flutter/material.dart';

import '../mainScreen/itemsScreen.dart';
import '../models/menus.dart';

class MenusDesignWidget extends StatefulWidget {
Menus? model;
BuildContext? context;


MenusDesignWidget({this.model, this.context});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //ItemsScreen
       Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model!,)));
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                child: Image.network(widget.model!.thumbnailUrl!,
                  height: 220,
                  fit: BoxFit.cover ,),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.model!.menuTitle!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),

                    Text(widget.model!.menuInfo!,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );;
  }
}
