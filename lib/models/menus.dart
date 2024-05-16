import 'package:cloud_firestore/cloud_firestore.dart';


class Menus {
  String? menuID;
  String? sellerID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuID,
    this.sellerID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
});

  Menus.fromJson(Map<String, dynamic> json){
    menuID = json["menuID"];
    sellerID = json["sellerID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic> ();
    data["menuID"]= menuID;
    data["sellerID"]= sellerID;
    data["menuTitle"]= menuTitle;
    data["menuInfo"]= menuInfo;
    data["publishedDate"]= publishedDate;
    data["thumbnailUrl"]= thumbnailUrl;
    data["status"]= status;
    return data;
  }
}