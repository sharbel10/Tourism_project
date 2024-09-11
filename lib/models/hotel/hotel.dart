import 'package:comeback/main.dart';

import '../privilege.dart';
import '../region.dart';

class Hotel{
  Hotel({this.id, this.name, this.stars, this.roomPrice, this.imagePaths,this.imagePath,
    this.region,this.description,this.privileges});
  int? id;
  String? name;
  String? description;
  String? stars;
  String? roomPrice;
  List<String>? imagePaths;
  String? imagePath;
  Region? region;
  List<Privilege>? privileges;

  factory Hotel.fromJson(Map<String,dynamic> data){
    List<dynamic> temp = data["images"] ?? [];
    List<dynamic> temp2 = data["previleges"] ?? [];
    return Hotel(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      imagePath: baseurl+"storage/${data["image"]?["path"]}",
      imagePaths: temp.map((e) => baseurl+"storage/${e["path"]}").toList(),
      region: Region.fromJson(data["region"]),
      roomPrice: data["price_per_room"],
      stars: data["stars"],
      privileges: temp2.map((e) => Privilege.fromJson(e)).toList(),
    );
  }
}