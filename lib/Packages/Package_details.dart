import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comeback/Packages/package_reservation.dart';
import 'package:comeback/tracking.dart';
import 'package:comeback/tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
// Define the Type model
class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});
  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Define the Package model
class Package {
  final List<Type> types;

  Package({required this.types});

  factory Package.fromJson(Map<String, dynamic> json) {
    var list = json['types'] as List;
    List<Type> typesList = list.map((i) => Type.fromJson(i)).toList();

    return Package(
      types: typesList,
    );
  }
}

class Package_Details extends StatefulWidget {
  Package_Details({super.key, this.id});
  final  id;
  @override
  State<Package_Details> createState() => _Package_DetailsState(id);
}

class _Package_DetailsState extends State<Package_Details> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool favourite = false;
  bool isLoading = true;
  bool hasError = false;
  List<String> regions = [];
  List<String> countries = [];
  _Package_DetailsState(this.id);
  final  id;
  List<String> image_profile = ["images/profile.jpg"];
  var images=[];
  Map<String, dynamic> packageData = {}; // Stores API data
  List<String> hotels = [] ;
  List<String> companies = [];
  List<Type> types = [];
  String packageName = 'Dream Trip';
  String adultPrice = '800\$';
  String childPrice = '500\$';
  String description = 'No description available';
  String packageImage = '';


  Future<void> view_package_details() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      var response = await http.get(
        Uri.parse('${baseurl}api/package/${widget.id}'),  // Assuming `widget.id` refers to the package ID passed to this widget
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("API Response: $responseData"); // Debugging

        if (responseData['status'] == true) {
          var data = responseData['data'] ?? {};

          setState(() {
            // Assign directly to the class-level packageData
            packageData = data['package'] ?? {};

            // Assign new data
            packageName = packageData['name']?.toString() ?? 'Dream Trip';
            adultPrice = packageData['adult_price']?.toString() ?? '800\$';
            childPrice = packageData['child_price']?.toString() ?? '500\$';
            description = packageData['description']?.toString() ?? 'No description available';
            packageImage = packageData['image']?.toString() ?? '';

            // Clear and update other lists
            hotels.clear();
            companies.clear();
            regions.clear();
            images.clear();
            types.clear();

            // Process images
            images = (packageData['images'] as List<dynamic>?)?.map((image) => image['path'].toString()).toList() ?? [];

            // Process package areas
            var packageAreas = packageData['package_areas'] ?? [];
            for (var area in packageAreas) {
              var visitable = area['visitable'] ?? {};
              if (area['visitable_type'] == 'Hotel') {
                hotels.add(visitable['name']?.toString() ?? 'Unknown Hotel');
              } else if (area['visitable_type'] == 'Region') {
                if (visitable['region_id'] == null) {
                  countries.add(visitable['name']?.toString() ?? 'Unknown Country');
                } else {
                  regions.add(visitable['name']?.toString() ?? 'Unknown Region');
                }
              }
            }

            // Process companies
            companies = (packageData['companies'] as List<dynamic>?)?.map((company) => company['name']?.toString() ?? 'Unknown Company').toList() ?? [];

            // Process types
            types = (packageData['types'] as List<dynamic>?)?.map((type) => Type.fromJson(type)).toList() ?? [];

            isLoading = false;
          });
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('An error occurred during loading: $e');
    }
  }

  List<Map<String, dynamic>> tripsData = [];
  Future<void> fetchTrips(int packageId) async {
    try {
      print("tripssss");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      var url = '${baseurl}api/package/trip/$id';
      print('Fetching trips from URL: $url');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Handle the data as a List
          List<dynamic> tripsDataList = List<dynamic>.from(responseData['data']);
          // Optionally, convert to a List<Map<String, dynamic>> if needed
          List<Map<String, dynamic>> tripsData = tripsDataList.map((item) => item as Map<String, dynamic>).toList();
          setState(() {
            this.tripsData = tripsData ; // Update your state with the trips data
            print(tripsData);
          });
        } else {
          print('Failed to load trips data: ${responseData['message']}');
        }
      } else {
        print('Failed to load trips with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred during loading trips: $e');
    }
  }



  Widget _buildTripsTab() {
    print(tripsData);
    if (tripsData.isEmpty) {
      return Center(
          child: Text("there is no trips to this package",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500),)
      );
    }
    else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: tripsData.length,
        itemBuilder: (context, index) {
          var trip = tripsData[index];
          var trip_id=trip['id'];
          var adult_price = double.tryParse(packageData['adult_price'].toString()) ?? 0.0;
          var child_price = double.tryParse(packageData['child_price'].toString()) ?? 0.0;
          print('Package Data: $packageData');
          print(adult_price);
          print(child_price);
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) {
                return PackageReservation(tripId:trip_id,adult_price:adult_price,child_price:child_price);
              },));
            },
            child: Card(
              color:Colors.teal.shade100,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  'Trip on ${trip['date']['date']}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Time: ${trip['time']}',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Tickets Available: ${trip['available_tickets']}',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8.0),
                    if (trip['available_tickets'] == 0)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Sold Out',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'
                          ),
                        ),
                      ),
                  ],
                ),
                leading: Icon(
                  Icons.trip_origin,
                  color: Colors.black,
                  size: 36.0,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                  size: 28.0,
                ),
              ),
            ),
          );
        },
      );
    }
  }



  @override
  void initState() {
    super.initState();
    tabController = TabController(length:4 , vsync: this);
    view_package_details();
    fetchTrips(id);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // if (hasError) {
    // return Scaffold(
    // body: Center(
    // child: Text('Failed to load data. Please try again later.'),
    // ),
    // );
    // }
    String countriesText = countries.join(', ');
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text('An error occurred'))
          : SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: packageImage.isNotEmpty? NetworkImage("${baseurl}storage/${packageImage}"):AssetImage("images/newback.jpg") as ImageProvider ,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      SizedBox(height: 588.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 15.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20).r,
                                topRight: Radius.circular(20).r,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                height: 8.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10).r,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 700.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35).r,
                            topLeft: Radius.circular(35).r,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    //right: 110,
                                      top: 10,left: 15 ).w,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      packageName,
                                      style: TextStyle(
                                        color: Color(0xff192149),
                                        fontSize: 23.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,right: 15),
                                  child:
                                  Text(
                                    adultPrice+'\$',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff192149),
                                    ),
                                  ),

                                ),
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 13),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    countriesText,
                                    style: TextStyle(color: Colors.grey, fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12, top: 10, bottom: 23),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    itemCount: 5,
                                    glow: true,
                                    glowRadius: 2,
                                    itemSize: 22,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  Container(
                                    child: Text(
                                      "(12 Reviews)",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    //  margin: EdgeInsets.only(right: 5),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.child_care,color: Colors.black,size: 22,),
                                            Icon(Icons.price_change,color: Colors.black,size: 22,),
                                          ],
                                        ),
                                        // Text(
                                        //   "child:",
                                        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            ':'+childPrice+'\$',
                                            style: TextStyle(
                                              fontSize: 15.spMin,
                                              color: Color(0xff192149),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: TabBar(
                                isScrollable: true,
                                controller: tabController,
                                labelColor: Colors.teal,
                                indicatorColor: Colors.teal,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Overview",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Reviews",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Gallery",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Trips",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Container(
                                  height: 450.h,
                                  child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            types.isEmpty ?
                                            Text("there is no types "):
                                            Container(
                                              height: 75.h,
                                              child: ListView.separated(
                                                separatorBuilder: (context, index) => SizedBox(width: 2),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: types.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                                                      height: 30,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white38,
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(
                                                          color: Colors.teal.withOpacity(0.8),
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.teal.withOpacity(0.4),
                                                            spreadRadius: 0.5,
                                                            offset: Offset(-1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.category_outlined,
                                                                color: Color(0xff192149),
                                                                size: 25,
                                                              ),
                                                              SizedBox(width: 3),
                                                              Flexible(
                                                                child: Text(
                                                                  types[index].name,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xff192149),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Regions:",
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 75.h,
                                              child: ListView.separated(
                                                separatorBuilder: (context, index) => SizedBox(width: 8.0),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: regions.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                                                      height: 30.h,
                                                      width: 160.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white38,
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(
                                                          color: Colors.teal.withOpacity(0.8),
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.teal.withOpacity(0.4),
                                                            spreadRadius: 0.5,
                                                            offset: Offset(-1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.location_city_outlined,
                                                                color: Color(0xff192149),
                                                                size: 25,
                                                              ),
                                                              SizedBox(width: 3),
                                                              Flexible(
                                                                child: Text(
                                                                  regions[index],
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xff192149),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Hotels:",
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            hotels.isEmpty
                                                ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "There are no hotels for this package",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                                : Container(
                                              height: 75.h,
                                              child: ListView.separated(
                                                separatorBuilder: (context, index) => SizedBox(width: 8.0),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: hotels.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                                                      height: 55,
                                                      width: 185,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white38,
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(
                                                          color: Colors.teal,
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.teal.withOpacity(0.4),
                                                            spreadRadius: 1,
                                                            offset: Offset(-1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.hotel,
                                                                color: Color(0xff192149),
                                                                size: 25,
                                                              ),
                                                              SizedBox(width: 5),
                                                              Flexible(
                                                                child: Text(
                                                                  hotels[index],
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xff192149),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Airplane Companies:",
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            companies.isEmpty
                                                ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "There are no companies for this package",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                                :
                                            Container(
                                              height: 88.h,
                                              child: ListView.separated(
                                                separatorBuilder: (context, index) => SizedBox(width: 20),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: companies.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                                                      height: 30,
                                                      width: 180,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white38,
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(
                                                          color: Colors.teal.withOpacity(0.8),
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.teal.withOpacity(0.4),
                                                            spreadRadius: 0.5,
                                                            offset: Offset(-1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.airplanemode_active,
                                                                color: Color(0xff192149),
                                                                size: 25,
                                                              ),
                                                              SizedBox(width: 3),
                                                              Flexible(
                                                                child: Text(
                                                                  companies[index],
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xff192149),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),



                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Description",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                description ?? '',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 5, // Placeholder count, update with actual reviews.length
                                        itemBuilder: (context, index) {
                                          // final review = reviews[index]; // Uncomment and use this line when reviews are available
                                          return Card(
                                            color: Colors.white70.withOpacity(0.9),
                                            elevation: 2,
                                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage("images/profile.jpg"),
                                                radius: 30,
                                              ),
                                              title: Text(
                                                'Anonymous',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              subtitle: Text(
                                                'No comment',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          height: 250,
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 0.8,
                                        ),
                                        items: images.map((imageUrl) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) => Container(
                                                      color: Colors.black,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: MediaQuery.of(context).size.height * 0.7,
                                                              child: InteractiveViewer(
                                                                child: Image.network(
                                                                  baseurl+'storage/'+imageUrl,
                                                                  fit: BoxFit.contain,
                                                                  height: MediaQuery.of(context).size.height, // Adjust as needed
                                                                  width: MediaQuery.of(context).size.width,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 10),
                                                            TextButton(
                                                              child: Text(
                                                                'Close',
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                              onPressed: () => Navigator.of(context).pop(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 6.0,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.network(
                                                      baseurl+'storage/'+imageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      _buildTripsTab(),
                                    ],
                                  ),
                                ),
                              ),
                            )


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 45.r,
              child: Container(
                width: 400.r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       favourite = !favourite;
                    //     });
                    //   },
                    //   child: Icon(
                    //     favourite ? Icons.bookmark : Icons.bookmark_outline,
                    //     size: 40,
                    //     color: favourite ? Colors.white : Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




