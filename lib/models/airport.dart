class Airport{
  Airport({this.name,this.id});
  int? id;
  String? name;

  factory Airport.fromJson(Map<String,dynamic> data){
    return Airport(
      id: data["id"],
      name: data["name"],
    );
  }
}