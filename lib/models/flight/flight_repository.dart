import 'package:comeback/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../airport.dart';
import '../company.dart';
import 'flight.dart';

class FlightRepository{

  Future<List<Airport>> getAllAirports() async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/airport",options: Options(
          headers: {
            "Authorization" : "Bearer ${token}",
          }
      ));
      if(r.statusCode == 200){
        List<dynamic> temp = r.data["data"]["airports"];
        return temp.map((e) => Airport.fromJson(e)).toList();
      }else{
        throw "Error";
      }
    }catch (e){
      rethrow;
    }
  }
  Future<List<Company>> getAllCompanies() async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    try{
      Response r = await dio.get(baseurl+"api/companies",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          }
      ));
      if(r.statusCode == 200){
        List<dynamic> temp = r.data["data"]["companies"];
        return temp.map((e) => Company.fromJson(e)).toList();
      }else{
        throw "Error";
      }
    }catch (e){
      rethrow;
    }
  }

  Future<List<Flight>> getAvailableFlights(int startAirportId,int endAirportId,int? companyId,String adultsNumber,String childrenNum,int classId,DateTime departureDate,DateTime? returnDate) async {
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      "start_airport_id" : startAirportId,
      "end_airport_id" : endAirportId,
      "adults_number" : adultsNumber,
      "children_number" : childrenNum,
      "class_id" : classId,
      "departure_date" : departureDate.toString(),
      if(returnDate != null) "return_date" : returnDate.toString(),
      "company_id" : companyId
    });
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.post(baseurl+"api/flights/search",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
            "Accept": "application/json",
          }
      ),data: data);
      if(r.data != null){
        List<dynamic> temp = r.data["data"]["flights"];
        return temp.map((e) => Flight.fromJson(e)).toList();
      }else{
        throw "Error";
      }
    }on DioException catch (e){
      rethrow;
    }
  }

}