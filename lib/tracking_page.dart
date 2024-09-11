import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'main.dart';

class TripTrackingScreen extends StatefulWidget {
  final int trip_Id;

  TripTrackingScreen({super.key, required this.trip_Id});

  @override
  _TripTrackingScreenState createState() => _TripTrackingScreenState(trip_Id);
}

class _TripTrackingScreenState extends State<TripTrackingScreen> {
  List<Map<String, dynamic>> trackingData = [];
  final int trip_id;

  _TripTrackingScreenState(this.trip_id);

  @override
  void initState() {
    super.initState();
    fetchTripTrackingData();
  }

  Future<void> fetchTripTrackingData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');

      var response = await http.get(
        Uri.parse('${baseurl}api/trip/tracking/$trip_id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          // Ensure 'tracking' is a List
          var data = responseData['data'];
          if (data is Map<String, dynamic> && data['tracking'] is List<dynamic>) {
            var trackingList = data['tracking'] as List<dynamic>;
            List<Map<String, dynamic>> listData = trackingList.map((e) => e as Map<String, dynamic>).toList();

            setState(() {
              trackingData = listData;
            });
          } else {
            print('Unexpected data structure: ${data}');
          }
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Failed to load tracking data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during loading trips: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Tracking'),
      ),
      body: trackingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: trackingData.length,
        itemBuilder: (context, index) {
          var item = trackingData[index];
          return TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.manual,
            lineXY: 0.2,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: _getIndicatorColor(item['status']),
            ),
            endChild: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item['name'] ?? 'No Name', // Default value if 'name' is missing
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            startChild: Container(
              height: 30,
              child: Center(
                child: Text(
                  _getStatusText(item['status']),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getIndicatorColor(int status) {
    switch (status) {
      case 2:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 0:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 2:
        return 'Visited';
      case 1:
        return 'Current';
      case 0:
        return 'Upcoming';
      default:
        return 'Unknown';
    }
  }
}
