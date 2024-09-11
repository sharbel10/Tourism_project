import 'city.dart';
import 'country/country.dart';

class Region{
  Region({this.id,this.country,this.name,this.regionId,this.description,this.imagePaths,this.cities});
  int? id;
  int? regionId;
  String? name;
  String? description;
  Country? country;
  List<String>? imagePaths;
  List<City>? cities;

  factory Region.fromJson(Map<String,dynamic> data){
    List<dynamic> temp = data["images"] ?? [];
    List<dynamic> temp2 = data["cities"] ?? [];
    return Region(
      id: data["id"],
      name: data["name"],
      country: data["country"] != null ? Country.fromJson(data["country"]) : null,
      regionId: data["region_id"],
      description: data["description"],
      imagePaths: temp.map((e) => e["path"] as String).toList(),
      cities: temp2.map((e) => City.fromJson(e)).toList(),
    );
  }
}