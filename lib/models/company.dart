

import 'country/country.dart';

class Company{
  Company({this.id, this.countryId, this.name, this.description,
    this.imagePath, this.country});

  int? id;
  int? countryId;
  String? name;
  String? description;
  String? imagePath;
  Country? country;

  factory Company.fromJson(Map<String,dynamic> data){
    return Company(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      country: Country.fromJson(data["country"]),
      imagePath: data["image"]["path"],
      countryId: data["country_id"]
    );
  }
}