import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/Auth/Verfication_code2.dart';
import 'package:comeback/Auth/Verification_code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'Loading_plane.dart';



class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  Future <void> _sendVerificationCode(String email) async {
    // Show custom loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlaneLoadingDialog();
      },
    );

    try {
      print("ssssssssssssssssssssssssss");
      var response = await http.post(
        Uri.parse(baseurl + 'api/send/forgotten/password/code'),
        body: {'email': email},
      );
      print("2323");
      var data = jsonDecode(response.body);
      print(data);
      String message = data['message'];

      // Close the loading indicator
      print(email);
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        if (data['status'].toString() == "true") {
          if (message == "A code is sent to your email, use it to allow you to change the password") {
            final snackBar = SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Check your email!',
                message: '${message}',
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return VerificationCodeInput2(email:_emailController.text);
              },
            ));
          }
        }
        if(data['status'].toString()=="false") {
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Sorry!',
              message: '${message}',
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          print(response.statusCode);
        }
      }
    } catch (e) {
      // Close the loading indicator if an error occurs
      Navigator.of(context).pop();

      // Handle any errors here
      print(e.toString());
      final snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'An error occurred. Please try again.',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 6.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Recover Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Enter your email address to receive a verification code:',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.teal)),
                          prefixIcon: Icon(Icons.email, color: Colors.teal),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {

                          if(_formKey.currentState!.validate()){
                            _sendVerificationCode(_emailController.text);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Send Verification Code',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
