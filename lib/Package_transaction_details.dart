import 'dart:convert';
import 'package:comeback/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comeback/package_transaction_model.dart';

class PackageDetailsPage extends StatefulWidget {
  final PackageTransactionDetails packageDetails;
  final int tripId;

  PackageDetailsPage({required this.packageDetails, required this.tripId});

  @override
  _PackageDetailsPageState createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  late Future<Map<String, dynamic>> reviewStatusFuture;
  double rating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reviewStatusFuture = fetchReviewStatus(widget.tripId);
  }

  Future<Map<String, dynamic>> fetchReviewStatus(int tripId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    final url = Uri.parse(baseurl+'api/can/review/$tripId');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('API Response Body: $responseBody');
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to load review status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review status: $e');
      throw Exception('Failed to fetch review status');
    }
  }
  Future<void> _submitRating(int tripId, double stars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    final url = Uri.parse(baseurl + 'api/add/rating');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'trip_detail_id': tripId,
          'stars': stars,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success response
        final responseBody = json.decode(response.body);
        if (responseBody['status']) {
          // Successfully submitted rating
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rating submitted successfully')),
          );
        } else {
          // Failed to submit rating
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit rating: ${responseBody['message']}')),
          );
        }
      } else {
        // Handle unexpected response status
        throw Exception('Failed to submit rating: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      print('Error submitting rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting rating')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
        backgroundColor: Colors.teal,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Transaction Details'),
                Tab(text: 'Review'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderSection(),
                          SizedBox(height: 16),
                          _buildTripInfoSection(),
                          SizedBox(height: 16),
                          _buildRenterInfoSection(),
                          SizedBox(height: 16),
                          _buildTransactionInfoSection(),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: reviewStatusFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Failed to load review status'));
                          } else if (snapshot.hasData) {
                            final reviewData = snapshot.data!;
                            final bool status = reviewData['status'] ?? false;
                            final String? message = reviewData['message'];
                            final Map<String, dynamic>? review = reviewData['data']?['review'];

                            print('Status: $status');
                            print('Message: $message');
                            print('Review: $review');

                            if (!status) {
                              return Center(child: Text(message ?? 'You cannot review this package.'));
                            }

                            if (review == null) {
                              // User can review and has not reviewed yet
                              return _buildAddReviewSection();
                            } else {
                              // User can review but has an old review
                              return _buildExistingReviewSection(review);
                            }
                          }
                          return Center(child: Text('No review data available'));
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.card_travel,
              color: Colors.teal,
              size: 40,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.packageDetails.packageName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Package ID: ${widget.packageDetails.id}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.teal),
              title: Text(
                'Time: ${widget.packageDetails.tripTime}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.date_range, color: Colors.teal),
              title: Text(
                'Date: ${widget.packageDetails.tripDate}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenterInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Renter Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.person, color: Colors.teal),
              title: Text(
                'Name: ${widget.packageDetails.renterName}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text(
                'Email: ${widget.packageDetails.renterEmail}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.group, color: Colors.teal),
              title: Text(
                'Adults: ${widget.packageDetails.adultNumber}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.child_care, color: Colors.teal),
              title: Text(
                'Children: ${widget.packageDetails.childrenNumber}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.teal),
              title: Text(
                'Total Price: \$${widget.packageDetails.totalPrice}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a Review',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: 8),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (ratingValue) {
            setState(() {
              rating = ratingValue;
            });
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Comment',
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _submitRating(widget.tripId, rating);
          },
          child: Text('Submit Rating'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitReview,
          child: Text('Submit Review'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildExistingReviewSection(Map<String, dynamic> review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Review',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: 8),
        RatingBar.builder(
          initialRating: (review['stars'] ?? 0).toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (ratingValue) {
            setState(() {
              rating = ratingValue;
            });
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: commentController..text = review['description'] ?? '',
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Comment',
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('updated successfully'),
                duration: Duration(seconds: 2), // Duration for which the SnackBar is visible
              ),
            );
          },
          child: Text('Update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            SnackBar(
              content: Text(' deleted successfully'),
              duration: Duration(seconds: 2), // Duration for which the SnackBar is visible
            );
          },
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Future<void> _submitReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    final url = Uri.parse('http://127.0.0.1:8000/api/reviews');
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    final body = json.encode({
      'type': 'Package',
      'trip_id': widget.tripId,
      'title': 'User Review',
      'description': commentController.text,
      'stars': rating.toInt(),
      'image': null // Adjust if you have image uploading functionality
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review submitted successfully')));
          setState(() {
            reviewStatusFuture = fetchReviewStatus(widget.tripId);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'] ?? 'Failed to submit review')));
        }
      } else {
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting review')));
    }
  }

  Future<void> _updateReview(int reviewId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    final url = Uri.parse('http://127.0.0.1:8000/api/reviews/$reviewId');
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    final body = json.encode({
      'title': 'User Review', // Add a title or modify accordingly
      'description': commentController.text,
      'stars': rating.toInt(),
      'image': null // Adjust if you have image uploading functionality
    });

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review updated successfully')));
          setState(() {
            reviewStatusFuture = fetchReviewStatus(widget.tripId);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'] ?? 'Failed to update review')));
        }
      } else {
        throw Exception('Failed to update review');
      }
    } catch (e) {
      print('Error updating review: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating review')));
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

    final url = Uri.parse('http://127.0.0.1:8000/api/reviews/$reviewId');
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review deleted successfully')));
          setState(() {
            reviewStatusFuture = fetchReviewStatus(widget.tripId);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'] ?? 'Failed to delete review')));
        }
      } else {
        throw Exception('Failed to delete review');
      }
    } catch (e) {
      print('Error deleting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting review')));
    }
  }
}
