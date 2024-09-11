import 'package:comeback/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../region.dart';
import 'country.dart';
class CountryRepository{

  Future<List<Country>> getCountries() async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/regions",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          }
      ));
      if(r.statusCode == 200){
        List<dynamic> temp = r.data["data"]["countries"];
        return temp.map((e) => Country.fromJson(e)).toList();
      }else{
        throw "Error";
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Region?> getCountryDetails(int id) async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/regions/$id",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          }
      ));
      if(r.statusCode == 200){
        return Region.fromJson(r.data["data"]["region"]);
      }else{
        throw "Error";
      }
    }catch (e){
      rethrow;
    }
  }
}