

import 'country/country.dart';

class City{
  City({this.id,this.country,this.imagePath,this.name,this.regionId});

  int? id;
  String? name;
  int? regionId;
  String? imagePath;
  Country? country;

  factory City.fromJson(Map<String,dynamic> data){
    return City(
      id: data["id"],
      imagePath: data["image"]["path"],
      name: data["name"],
      regionId: data["region_id"],
      country: Country.fromJson(data["country"]),
    );
  }
}