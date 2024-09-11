class FavoriteList{
  FavoriteList({this.id,this.name});
  int? id;
  String? name;

  factory FavoriteList.fromJson(Map<String,dynamic> data){
    return FavoriteList(
      id: data["id"],
      name: data["name"]
    );
  }
}