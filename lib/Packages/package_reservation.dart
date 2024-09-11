import 'package:comeback/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/Loading_plane.dart';
import '../Auth/Snackbar.dart';
import '../Create_Wallet.dart';
import 'Packages.dart';

class PackageReservation extends StatefulWidget {
  final int tripId;
  final double adult_price;
  final double child_price;

  PackageReservation({required this.tripId, required this.adult_price, required this.child_price});

  @override
  _PackageReservationState createState() => _PackageReservationState();
}

class _PackageReservationState extends State<PackageReservation> {
  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isNotYou = false;
  double _totalPrice = 0.0;

  @override
  void dispose() {
    _adultsController.dispose();
    _childrenController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    final int adults = int.tryParse(_adultsController.text) ?? 0;
    final int children = int.tryParse(_childrenController.text) ?? 0;

    setState(() {
      _totalPrice = (adults * widget.adult_price) + (children * widget.child_price);
    });
  }

  void _submitReservation() async {
    final int adults = int.tryParse(_adultsController.text) ?? 0;
    final int children = int.tryParse(_childrenController.text) ?? 0;
    final String name = _isNotYou ? _nameController.text : '';
    final String email = _isNotYou ? _emailController.text : '';
    final String? walletPassword = await _showWalletPasswordDialog();

    if (walletPassword != null) {
      package_reservation(
        widget.tripId,
        name,
        email,
        adults,
        children,
        walletPassword,
        context,
      );
    }
  }

  Future<String?> _showWalletPasswordDialog() {
    final TextEditingController _passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Wallet Password',style: TextStyle(fontWeight: FontWeight.bold),),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: Colors.teal)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // User canceled
              },
              child: Text('Cancel',style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_passwordController.text); // Return password
              },
              child: Text('Submit',style: TextStyle(color: Colors.teal),),
            ),
          ],
        );
      },
    );
  }

  Future<void> package_reservation(
      int tripId,
      String name,
      String email,
      int adultNumber,
      int childNumber,
      String walletPassword,
      BuildContext context
      ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlaneLoadingDialog();
      },
    );

    try {
      // Create MultipartRequest
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseurl+'api/package/transaction'),
      );

      // Add headers
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token') ?? '';
      print(token);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      // Add fields to the request
      request.fields.addAll({
        'trip_detail_id': tripId.toString(),
        'adult_number': adultNumber.toString(),
        'wallet_password': walletPassword,
        'children_number':childNumber.toString(),
      });

      if (email.isNotEmpty) {
        request.fields['email'] = email;
      }

      if (name.isNotEmpty) {
        request.fields['name'] = name;
      }

      // if (childNumber > 0) {
      //   request.fields['children_number'] = childNumber.toString();
      // }

      // Send the request
      final response = await request.send();

      // Convert response to http.Response
      final httpResponse = await http.Response.fromStream(response);
      final responseBody = httpResponse.body;

      // Print response body for debugging
      print('Response body: $responseBody');

      // Decode JSON response
      var data = jsonDecode(responseBody);
      Navigator.of(context).pop();

      // Handle response
      String message = data["message"];
      if (response.statusCode == 200) {
        if (data['status'].toString() == "true") {
          showSuccessSnackbar(context, message);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Packages()));
        } else if (data['status'].toString() == 'false' && message == "You don't have a wallet, please create one") {
          showErrorSnackbar(context, message);
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWalletScreen(token: token)));
        } else {
          showErrorSnackbar(context, message);
        }
      } else {
        showErrorSnackbar(context, "Unexpected error occurred: ${response.statusCode}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showErrorSnackbar(context, "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Your Package',style: TextStyle(fontFamily: 'Montserrat'),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Reservation Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _adultsController,
                        labelText: 'Number of Adults',
                        hintText: 'Enter number of adults',
                        icon: Icons.person,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _updateTotalPrice(), // Update the total cost
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _childrenController,
                        labelText: 'Number of Children',
                        hintText: 'Enter number of children',
                        icon: Icons.child_care,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _updateTotalPrice(), // Update the total cost
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(
                          "Reserve for someone else?",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: _isNotYou,
                        activeColor: Colors.teal,
                        onChanged: (bool value) {
                          setState(() {
                            _isNotYou = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_isNotYou)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Traveler Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _nameController,
                          labelText: 'Name',
                          hintText: 'Enter traveler\'s name',
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter traveler\'s email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                ),
                child: Text(
                  'Reserve Now',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Montserrat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged, // Add an optional onChanged callback
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged, // Trigger the callback on text change
    );
  }
}
