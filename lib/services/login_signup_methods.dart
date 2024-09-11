import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/modules/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/Loading_plane.dart';
import '../Auth/Snackbar.dart';
import '../Auth/Verification_code.dart';
import '../Packages/Packages.dart';
import '../main.dart';


Future <void> signup(String name, String email, String password, String confirm_password,var phone ,BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PlaneLoadingDialog();
    },
  );
  var request  = await http.MultipartRequest('POST',
      Uri.parse(baseurl+"api/singup"));
  request.fields.addAll({
    'name': name,
    'email':email,
    'password':password,
    'password_confirmation': confirm_password,
  });
  if(phone!=""){
    request.fields.addAll(
        {
          'phone_number': phone
        }
    );
  }
  final response=await request.send();

  try {
    final jsonres = await http.Response.fromStream(response);
    var data = jsonDecode(jsonres.body);
    Navigator.of(context).pop();
    String message = data["message"];
    if (response.statusCode == 200) {
      print(data);
      print(data['status']);
      if (data['status'].toString() == "true") {
        var tok = data ['data']['token'];
        print(tok);

        showSuccessSnackbar(context, message);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return VerificationCodeInput(token: tok);
        },));
      }
      if (data['status'].toString() == 'false') {
        print(response.statusCode);
        showErrorSnackbar(context, message);
      }
    }
    if (response.statusCode == 401) {
      String message = data["message"];
      showErrorSnackbar(context, message);
    }
  }
  catch(e){
    print(e);
  }
}
Future<void> login(String email, String password, BuildContext context) async {
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
      Uri.parse(baseurl + 'api/login'),
      body: {'email': email, 'password': password,'is_admin': '0'},
    );
    print("2323");
    var data = jsonDecode(response.body);
    print(data);
    String message = data['message'];

    // Close the loading indicator
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      if (data['status'].toString() == "true") {
        if (message == "logged in successfully") {
          var token = data['data']['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('login_token', token);
          print('the token is :  ${token}');
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Welcome!',
              message: '${message}',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return homepage();
            },
          ));
        }
        if (message == "Please verify your email, code is sent to you") {
          var token = data['data']['token'];
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Email Verify is needed',
              message: '${message}',
              contentType: ContentType.warning,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return VerificationCodeInput(token: token);
            },
          ));
        }
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: 'Login failed!',
            message: '${message}',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        print(response.statusCode);
      }
    } else if (response.statusCode == 401) {
      final snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: 'Login failed!',
          message: '${message}',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
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
Future<void> SignupWithGoogle(String email, String name, String googleId, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PlaneLoadingDialog();
    },
  );
  try {
    var response = await http.post(
      Uri.parse(baseurl + 'api/google/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'google_id': googleId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("suio");
      var data = jsonDecode(response.body);
      String message = data['message'];
      if (data['status'].toString() == "true") {
        print("object");
        Navigator.of(context).pop();
        var token = data['data']['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('login_token', token);
        print('The token is: $token');
        showSuccessSnackbar(context, message);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Packages(),
        ));
      }
      else {
        Navigator.of(context).pop();
        showErrorSnackbar(context, message);
      }
    }
    else {
      Navigator.of(context).pop();
      showErrorSnackbar(context, "Server error: ${response.statusCode}");
    }
  } catch (e) {
    Navigator.of(context).pop();
    print("Error during login with Google: $e");
    showErrorSnackbar(context, "An error occurred. Please try again.");
  }
}
Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // User canceled the sign-in
      throw Exception("Sign-in aborted by user");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in with Firebase
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Extract user information
    String userEmail = googleUser.email!;
    String? userName = googleUser.displayName!;
    String googleId = googleUser.id;

    print('User email: $userEmail');
    print('Username: $userName');
    print('Google ID: $googleId');

    // Pass context to the loginWithGoogle function
    await SignupWithGoogle(userEmail, userName, googleId, context);

    return userCredential;
  } catch (e, stackTrace) {
    print("Error during Google sign-in: $e");
    print("Stack trace: $stackTrace");

    if (e is PlatformException && e.code == "status") {
      // Handle specific error case
      showErrorSnackbar(context, "Failed to disconnect from Google. Please try again.");
    } else {
      // General error handling
      showErrorSnackbar(context, "Error during Google sign-in. Please try again.");
    }

    return null; // Return null or handle as needed
  }
}
Future<void> LoginWithGoogle(String email,String googleId, BuildContext context) async {


  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PlaneLoadingDialog();
    },
  );
  try {
    var response = await http.post(
      Uri.parse(baseurl + 'api/google/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'google_id': googleId,
        'is_admin':0
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String message = data['message'];
      if (data['status'].toString() == "true") {
        Navigator.of(context).pop();
        var token = data['data']['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('login_token', token);
        print('The token is: $token');
        showSuccessSnackbar(context, message);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Packages(),
        ));
      } else {
        Navigator.of(context).pop();
        showErrorSnackbar(context, message);
      }
    } else {
      Navigator.of(context).pop();
      showErrorSnackbar(context, "Server error: ${response.statusCode}");
    }
  } catch (e) {
    Navigator.of(context).pop();
    print("Error during login with Google: $e");
    showErrorSnackbar(context, "An error occurred. Please try again.");
  }
}
Future<UserCredential?> loginInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // User canceled the sign-in
      throw Exception("Sign-in aborted by user");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in with Firebase
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Extract user information
    String userEmail = googleUser.email!;
    String? userName = googleUser.displayName!;
    String googleId = googleUser.id;

    print('User email: $userEmail');
    print('Username: $userName');
    print('Google ID: $googleId');

    // Pass context to the loginWithGoogle function
    await LoginWithGoogle(userEmail,googleId,context);

    return userCredential;
  } catch (e, stackTrace) {
    print("Error during Google sign-in: $e");
    print("Stack trace: $stackTrace");

    if (e is PlatformException && e.code == "status") {
      // Handle specific error case
      showErrorSnackbar(context, "Failed to disconnect from Google. Please try again.");
    } else {
      // General error handling
      showErrorSnackbar(context, "Error during Google sign-in. Please try again.");
    }

    return null; // Return null or handle as needed
  }
}







