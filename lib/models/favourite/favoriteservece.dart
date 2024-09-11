import 'package:comeback/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'favoritemodel.dart';
// import 'favorite_model.dart'; // Import the model class

class ApiService {
  final Dio _dio = Dio();
  static  String url = baseurl+'api/favorite';



  Future<FavoriteResponse> fetchFavorites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      print(token);
      final response = await _dio.get(url,options: Options(headers: {
         'Authorization': 'Bearer ${token}',
      }));

      if (response.statusCode == 200) {
        return FavoriteResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load favorite lists');
      }
    } on DioError catch (e) {
      throw Exception('Failed to load favorite lists: ${e.message}');
    }
  }
}