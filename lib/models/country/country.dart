class Country{
  Country({this.id,this.name,this.description});
  int? id;
  String? name;
  String? description;

  factory Country.fromJson(Map<String,dynamic> data){
    return Country(
      id: data["id"],
      name: data["name"],
      description: data["description"]
    );
  }
}