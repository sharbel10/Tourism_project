// iimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../models/favourite/favoritemodel.dart';
import '../../models/favourite/favoriteservece.dart';

// import 'favorite_model.dart'; // Import the model class
// import 'api_service.dart'; // Import the service class

class FavoriteListWidget extends StatefulWidget {
  @override
  _FavoriteListWidgetState createState() => _FavoriteListWidgetState();
}

class _FavoriteListWidgetState extends State<FavoriteListWidget> {
  late Future<FavoriteResponse> futureFavorites;

  @override
  void initState() {
    super.initState();
    futureFavorites = ApiService().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    var Lists =['My favourite', 'fav','sharbel'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Lists'),
      ),
      body:
       ListView.builder(
    itemCount: Lists.length,
      itemBuilder: (context, index) {
        // var lists;
        return ListTile(
          title: Text(Lists[index]),
          trailing: IconButton(onPressed: () {
            Lists.removeAt(index);
          }, icon: Icon(Icons.delete,color: Colors.red,),),
        );
      },
    ),
    );
  }
}