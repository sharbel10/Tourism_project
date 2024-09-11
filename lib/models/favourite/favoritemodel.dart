class FavoriteList {
  final int id;
  final String name;

  FavoriteList({required this.id, required this.name});

  factory FavoriteList.fromJson(Map<String, dynamic> json) {
    return FavoriteList(
      id: json['id'],
      name: json['name'],
    );
  }
}

class FavoriteResponse {
  final bool status;
  final String message;
  final List<FavoriteList> lists;

  FavoriteResponse({required this.status, required this.message, required this.lists});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['lists'] as List;
    List<FavoriteList> favoriteLists = list.map((i) => FavoriteList.fromJson(i)).toList();

    return FavoriteResponse(
      status: json['status'],
      message: json['message'],
      lists: favoriteLists,
    );
  }
}
