import 'package:comeback/Packages/Package_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart'; // Ensure this imports your baseurl

class CustomSearchDelegate extends SearchDelegate<String> {
  int _selectedTabIndex = 0;
  List<String> _packageTypes = [];
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> _fetchPackageTypes() async {
    final url = '${baseurl}api/packageTypes';
    final response = await _fetchWithAuth(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final types = data['data'] as List<dynamic>;
        _packageTypes = types.map((type) => type['name'].toString()).toList();
      } else {
        throw Exception('Failed to fetch package types');
      }
    } else {
      throw Exception('Failed to load package types');
    }
  }

  Future<List<String>> _fetchSuggestions() async {
    final url = '${baseurl}api/package';
    final response = await _fetchWithAuth(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final packages = data['data']['packages'] as List<dynamic>;
        final packageNames = packages.map<String>((pkg) => pkg['name'] as String).toList();
        final countryNames = packages.expand((pkg) => (pkg['countries'] as List<dynamic>).map((c) => c['name'] as String)).toList();
        final allSuggestions = <String>{};
        allSuggestions.addAll(packageNames);
        allSuggestions.addAll(countryNames);
        return allSuggestions.toList();
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<List<dynamic>> _fetchPackages(String query, String? packageType) async {
    final url = '${baseurl}api/package?search=${Uri.encodeComponent(query)}' +
        (packageType != null ? '&type=${Uri.encodeComponent(packageType)}' : '');
    final response = await _fetchWithAuth(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        print(data);
        return data['data']['packages'];

      } else {
        throw Exception('Failed to fetch packages');
      }
    } else {
      throw Exception('Failed to load packages');
    }
  }

  Future<http.Response> _fetchWithAuth(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');
    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${token}',
      },
    );
  }

  CustomSearchDelegate() {
    _fetchPackageTypes();
  }

  @override
  String? get searchFieldLabel => 'Search by country, place';

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 16,);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context,query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return DefaultTabController(
      length: _packageTypes.length + 1,
      animationDuration: Duration(seconds: 1),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          //backgroundColor: Colors.teal,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.teal,
            indicatorColor: Colors.teal,
            unselectedLabelColor: Colors.black,

            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),

            onTap: (index) {
              _selectedTabIndex = index;
              showResults(context);
            },
            tabs: [
              Tab(text: 'All'),
              ..._packageTypes.map((type) => Tab(text: type)).toList(),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _hasError
            ? Center(child: Text('Error fetching results', style: TextStyle(color: Colors.red)))
            : TabBarView(
          children: [
            _buildPackagesList(null),
            ..._packageTypes.map((type) => _buildPackagesList(type)).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchSuggestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suggestions found', style: TextStyle(color: Colors.grey)));
        } else {
          final suggestions = snapshot.data!;
          final filteredSuggestions = query.isEmpty
              ? suggestions
              : suggestions.where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase())).toList();
          return ListView.builder(
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = filteredSuggestions[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                leading: Icon(Icons.location_city_outlined, color: Colors.teal,size: 24,),
                title: Text(suggestion, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
              //  tileColor: Colors.teal.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }


  Widget _buildPackagesList(String? packageType) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchPackages(query, packageType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found for ${packageType ?? 'all types'}', style: TextStyle(color: Colors.grey)));
        } else {
          final packages = snapshot.data!;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              final  id= packages[index]['id'];
              final image = packages[index]['image'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: image != null
                            ? DecorationImage(
                          image: NetworkImage(baseurl + 'storage/' + image),
                          fit: BoxFit.fill,
                        )
                            : null, // No image decoration if image is null
                      ),
                      child: image == null
                          ? Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                          : null, // Show an icon if the image is null
                    ),
                    title: Text(pkg['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Montserrat')),
                    subtitle: Text(
                      'Adult Price: \$${pkg['adult_price']}\n'
                          'Child Price: \$${pkg['child_price']}\n'
                          'Period: ${pkg['period']} days',
                      style: TextStyle(color: Colors.grey[700], fontFamily: 'Montserrat'),
                    ),
                    tileColor: Colors.teal.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Package_Details(id: id);
                      }));
                    },
                  ),
                ),
              );


            },
          );
        }
      },
    );
  }
}
