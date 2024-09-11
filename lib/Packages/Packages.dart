import 'dart:async';
import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Search_package.dart';
import '../main.dart';
import '../token.dart';
import 'Package_details.dart';

class Packages extends StatefulWidget {
  Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages>
    with SingleTickerProviderStateMixin {
  bool favourite = false;
  TabController? tabController;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var data = [];
  bool _isDataFetched = false;
  bool _isDataFetched2 = false;
  List<String> _packageTypes = [];
  List<dynamic> topRatedPackages = [];


  @override
  void initState() {
    super.initState();
    fetchPackageTypes().then((types) {
      setState(() {
        _packageTypes = types;
        tabController = TabController(length: _packageTypes.length + 1, vsync: this);
        tabController!.addListener(_handleTabChange); // Add listener to TabController
      });
      view_all_packages();
      fetchTopRatedPackages();
    });
  }

  void _handleTabChange() {
    if (tabController?.indexIsChanging ?? false) {
      String? selectedType = tabController?.index == 0 ? null : _packageTypes[tabController!.index - 1];
      fetchFilteredPackages(selectedType); // Fetch filtered packages based on selected tab
    }
  }






  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }



  void onPackageTap(int packageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Package_Details(id: packageId),
      ),
    );
  }

  Future<void> fetchTopRatedPackages() async {
    print("lolooooooooooooooooooooooooooooo");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      var response = await http.get(
        Uri.parse('${baseurl}api/package_top_rating'), // Replace with your actual API endpoint
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'].toString() == 'true') {
          List<dynamic> packages = responseData['data']['packages'];
          setState(() {
            topRatedPackages = packages;
            print(topRatedPackages);
         
          });
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Loading failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during loading: $e');
    }
  }

  Future<void> view_all_packages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      var response = await http.get(
        Uri.parse('${baseurl}api/package'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'].toString() == 'true') {
          List<dynamic> packages = responseData['data']['packages'];
          setState(() {
            data = packages;
            _isDataFetched = true;
          });
        }
      } else {
        print('Loading failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during loading: $e');
    }
  }

  Future<void> fetchFilteredPackages(String? type) async {
    print("sssssssssssssssssssssssssssssssssssss");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      var uri = Uri.parse('${baseurl}api/package');
      if (type != null) {
        print("suiiiiiii");
        uri = Uri.parse('${baseurl}api/package?type=$type');
      }
      var response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'].toString() == 'true') {
          print("object");
          List<dynamic> packages = responseData['data']['packages'];
          setState(() {
            data = packages;
            print(data);
            _isDataFetched = true;
          });
        }
      } else {
        print('Fetching filtered packages failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during fetching filtered packages: $e');
    }
  }


  Future<List<String>> fetchPackageTypes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      var response = await http.get(
        Uri.parse('${baseurl}api/packageTypes'),
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      );

      print(token);
      // Debugging: Print response status and body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'].toString() == 'true') {
          final List<dynamic> types = data['data'];
          return types.map((type) => type['name'].toString()).toList();

        } else {
          throw Exception('Failed to load package types, status false');
        }
      } else {
        throw Exception('Failed to load package types, status code ${response.statusCode}');
      }
    } catch (e) {
      // Print the error to the console
      print('An error occurred: $e');
      throw Exception('Failed to load package types');
    }
  }





  Future<void> logout(BuildContext context) async {
    try {
      // Retrieve the token from SharedPreferences

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      prefs.remove('login_token');
      print(token);
      // Send a logout request to the API
      var response = await http.delete(
        Uri.parse('${baseurl}api/logout'),
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data['message']);
        // Clear the token from SharedPreferences
        await prefs.remove('login_token');
        Navigator.of(context).pushReplacementNamed('/LoginorSignup');
      } else {
        // Handle the error, maybe show an alert to the user
        print('Logout failed with status code: ${response.statusCode}');
        print(token);
      }
    } catch (e) {
      // Handle any exceptions here
      print('An error occurred during logout: $e');
    }
  }


  Widget _buildTabContent(String? type) {
    print("whaattffff");
    if (!_isDataFetched) {
      print("shoshu");
      return Center(child: CircularProgressIndicator(color: Colors.teal));
    } else {
      print("lest go");
      final filteredData = type == null
          ? data // Show all packages
          : data.where((package) => package['type'] ==  type).toList(); // Filtered packages
      print("lest goooooooo");
      return data.isEmpty?CircularProgressIndicator(color: Colors.teal,):ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var package = data[index];
          var packageId = package['id'];
          var imageUrl = '${baseurl}storage/${package['image']}';
          // Safely extract rating or set default value
          var ratingData = package['rating'];
          var ratingStars = ratingData != null && ratingData['stars'] != null
              ? ratingData['stars'].toString()
              : 'No rating';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                onPackageTap(packageId);
              },
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black38),
                  image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
                ),
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 130, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    favourite=!favourite;
                                  });
                                },
                                child: Icon(
                                  favourite ? Icons.bookmark : Icons.bookmark_outline,
                                  size: 34,
                                  color: favourite ? Colors.white : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                package['name'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    package['countries'][0]['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text(
                                  ratingStars,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  Text(
                                    "${package['adult_price']}\$",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 4),
                                  child: Icon(Icons.watch_later_outlined, color: Colors.white),
                                ),
                                Text(
                                  "${package['period']} days",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Hi, Sharbel"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    content: Text(
                      'are you sure you want to logout of this account?',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 20)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Logout',
                            style:
                            TextStyle(color: Colors.white, fontSize: 20)),
                        onPressed: () async{
                          logout(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
            color: Color(0xff29292d),
          ),
          // IconButton(onPressed: () {
          //   setState(() {
          //     favourite=!favourite;
          //   });
          // }, icon: Icon(favourite?Icons.bookmark:Icons.bookmark_outline,color: Colors.white,size: 30,))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's choose",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(-1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "a travel route",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(-1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.86,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white38,
                        style: BorderStyle.solid,
                        width: 2.r,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(-1, 1),
                          blurRadius: 1,
                          blurStyle: BlurStyle.solid,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xffbababc),
                            size: 30,
                          ),
                        ),
                        Text(
                          "Search a trip by country, place",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (tabController != null) ...[
              Container(
                height: 45,
                margin: EdgeInsets.only(top: 10),
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  labelColor: Colors.teal,
                  indicatorColor: Colors.teal,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Montserrat',
                  ),
                  tabs: [
                    Tab(text: "All"),
                    ..._packageTypes.map((type) => Tab(text: type)).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 320,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _buildTabContent(null), // Show all packages
                        ..._packageTypes.map((type) => _buildTabContent(type)).toList(), // Filtered by type
                      ],
                    ),
                  ),
                ),
              ),
            ],

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  // margin: EdgeInsets.only(left: ),
                  child: Text(
                    "Top Rated",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 310,
              child: Swiper(
                itemCount: topRatedPackages.length, // Use the length of topRatedPackages
                itemWidth: 250,
                itemHeight: 320,
                layout: SwiperLayout.STACK,
                axisDirection: flipAxisDirection(AxisDirection.left),
                scrollDirection: Axis.horizontal,
                allowImplicitScrolling: true,
                curve: Curves.easeInOut,
                autoplay: true,
                autoplayDisableOnInteraction: false,
                itemBuilder: (context, index) {
                  var package = topRatedPackages[index];
                  var imageUrl = package['image']!= null
                      ? '${baseurl}storage/${package['image']}'
                      : 'assets/placeholder_image.jpg'; // Provide a placeholder image if image is null
                  // Safely extract rating or set default value
                  var ratingData = package['rating'];
                  var ratingStars = ratingData != null && ratingData['stars'] != null
                      ? ratingData['stars'].toString()
                      : 'No rating';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image:
                            NetworkImage(imageUrl),
                            fit: BoxFit.cover),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 400,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Text(
                                      package['name'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          package['countries'][0]['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow),
                                      Text(
                                        ratingStars,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.white),
                                        Text(
                                          "${package['adult_price']}\$",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined, color: Colors.white),
                                      Text(
                                        "${package['period']} days",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

          ],

        ),
      ),
    );
  }
}





















