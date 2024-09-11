import 'package:comeback/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hotel.dart';

class HotelRepository{
  Future<Map<String,List<Hotel>>> getHomeHotels() async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/hotels",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          }
      ));
      print(r.statusMessage);
      if(r.statusCode == 200){
        List<dynamic> temp = r.data["data"]["home_hotels"];
        List<dynamic> temp2 = r.data["data"]["all_hotels"];
        return {
          "home_hotels" : temp.map((e) => Hotel.fromJson(e)).toList(),
          "all_hotels" : temp2.map((e) => Hotel.fromJson(e)).toList(),
        };
      }else{
        throw "Error";
      }
    }catch (e){
      print(e);
      rethrow;
    }
  }

  Future<Hotel?> getHotelDetails(int id) async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/hotels/$id",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          }
      ));
      // print(r.data);
      if(r.statusCode == 200){
        return Hotel.fromJson(r.data["data"]["hotel"]);
      }else{
        throw "Error";
      }
    }catch (e){
      rethrow;
    }
  }
}