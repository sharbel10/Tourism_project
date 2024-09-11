class Privilege{
  Privilege({this.id,this.name});
  int? id;
  String? name;

  factory Privilege.fromJson(Map<String,dynamic> data){
    return Privilege(id: data["id"],name: data["name"]);
  }
}