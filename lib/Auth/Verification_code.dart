import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/Create_Wallet.dart';
import 'package:comeback/main.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Packages/Packages.dart';
import 'Loading_plane.dart';

class VerificationCodeInput extends StatelessWidget {
  VerificationCodeInput({super.key,  this.token});
  var token;

  Future verification(String pin_code, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlaneLoadingDialog();
      },
    );
    print("ssssssssssssssssssssssssss");
    print(token);
    var response = await http.post(
        Uri.parse(baseurl+'api/code/validation'),
        headers: {
          'Authorization':'Bearer ${token}'
        },
        body: {
          'code': pin_code
        }
    );

    print(response.statusCode);
    print("alshosh");
    try {
      var data = jsonDecode(response.body);
      print("shhist");
      print(data);
      String message = data['message'];
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        if (data['status'].toString() == "true") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('login_token', token);
          print('the token is :  ${token}');
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Email verifacted correctly!',
              message: '${message}',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return CreateWalletScreen(token: token,);
            },
          ));
        }


        if (data['status'].toString() == 'false') {
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Sorry',
              message: '${message}',
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    }
    catch(e){
      print(e);
      print("Ah shiiit");
    }

  }



  Future resend_verification(BuildContext context)async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlaneLoadingDialog();
      },
    );
    var response = await http.get(
      Uri.parse(baseurl + 'api/resend/verification/code'),
      headers: {
        'Authorization': 'Bearer ${token}'
      },
    );
    try {
      var data = jsonDecode(response.body);
      var message = data ['message'];
      if (response.statusCode == 200) {
        if (data['status'].toString() == 'true' &&
            message == "A verification code is sent to your email") {
          print("object");
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Check your email',
              message: '${message}',
              contentType: ContentType.help,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
        if (data['status'].toString() == 'true' &&
            message == "") {
          print("object");
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Check your email',
              message: '${message}',
              contentType: ContentType.help,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }


        if (data['status'].toString() == 'false') {
          print("sshhhh");
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
        }
      }
    }
    catch(e){
      print(e);
    }
  }



  Widget build(BuildContext context) {
    TextEditingController pin_code = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.teal.shade700,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.teal.shade300,style: BorderStyle.solid,width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.teal),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.teal.shade100,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(

        margin: EdgeInsets.only(top: 80),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verification Code',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please enter the code sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal.shade700,
              ),
            ),
            Spacer(),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              showCursor: true,
              controller: pin_code,
              onCompleted: (pin) {
                // Handle the entered pin code
                print('Entered PIN: $pin');
              },
            ),
            Spacer(flex: 1),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle the verify button press
                      print('Verify button pressed');
                      print(pin_code.text);
                      verification(pin_code.text, context);
                    },
                    child: Text('Verify',style: TextStyle(color: Colors.white,fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        // Handle the resend code button press
                        print('Resend Code button pressed');
                        resend_verification(context);
                      },
                      child: Text('Resend Code',style: TextStyle(color: Colors.teal,fontSize: 20),),
                      style: TextButton.styleFrom(
                        surfaceTintColor:  Colors.teal.shade200,
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
}

