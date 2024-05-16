class Sellers{

  String? sellerUID;
  String? sellerName;
  String? sellerAvatarUrl;
  String? sellerEmail;
  String? sellerRestaurantStatus;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvatarUrl,
    this.sellerEmail,
    this.sellerRestaurantStatus,
});

  Sellers.fromJson(Map<String, dynamic> json){
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvatarUrl = json["sellerAvatarUrl"];
    sellerEmail = json["sellerEmail"];
    sellerRestaurantStatus = json["restaurant_status"];
  }


  Map<String, dynamic> toJson (){
    final Map<String, dynamic> data = new Map<String, dynamic> ();
    data["sellerUID"] =this.sellerUID;
    data["selleName"] =this.sellerName;
    data["sellerAvatarUrl"] =this.sellerAvatarUrl;
    data["sellerEmail"] =this.sellerEmail;
    data["restaurant_status"] =this.sellerRestaurantStatus;
    return data;
  }
}