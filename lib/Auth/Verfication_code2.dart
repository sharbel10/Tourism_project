import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/main.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Packages/Packages.dart';
import 'Loading_plane.dart';
import 'New_password.dart';

class VerificationCodeInput2 extends StatelessWidget {
  VerificationCodeInput2( {super.key, required this.email});
  String email;
  Future verification(String pin_code, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlaneLoadingDialog();
      },
    );
    print("ssssssssssssssssssssssssss");
    var response = await http.post(
        Uri.parse(baseurl+'api/validate/forgotten/password/code'),

        body: {
          'email':email,
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
      String reset_token;
      if (response.statusCode == 200) {
        if (data['status'].toString() == "true") {
          reset_token = data['data']['reset_token'];
          print('the reset_token is :  ${reset_token}');
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Done!',
              message: '${message}',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return ResetPasswordPage(reset_token: reset_token,email: email,);
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
      // appBar: AppBar(
      //   title: Padding(
      //     padding: const EdgeInsets.only(top: 20),
      //     child: Text('Enter Verification Code',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      //   ),
      //   backgroundColor: Colors.teal,
      // ),
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Handle the resend code button press
                  //       print('Resend Code button pressed');
                  //
                  //    //   resend_verification(context);
                  //     },
                  //     child: Text('Resend Code',style: TextStyle(color: Colors.teal,fontSize: 20),),
                  //     style: TextButton.styleFrom(
                  //       primary: Colors.teal.shade200,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

