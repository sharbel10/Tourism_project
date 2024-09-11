import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/modules/home/homepage.dart';
import 'package:comeback/token.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:comeback/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:comeback/passwordbloc/PasswordVisibility_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/Loading_plane.dart';
import 'Packages/Packages.dart';

class CreateWalletScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();

  var token;

  CreateWalletScreen({super.key,this.token});
  Future<void> create_wallet(String password, String confirm_password,BuildContext context) async {
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
        Uri.parse(baseurl + 'api/wallet/create'),
        headers:{ 'Authorization' :'Bearer ${token}'},
        body: {'password': password, 'password_confirmation':confirm_password,},
      );
      print("2323");
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print(data);
      String message = data['message'];
      // Close the loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        if (data['status'].toString() == "true") {
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
        if(data['status']== 'false'){
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Wallet not created!',
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
    }
    catch (e) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image at the top
              Container(
                margin: EdgeInsets.only(top: 60.h),
                height: 80.h,
                width: 120.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/wallet.jpg"),
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                  ),
                  borderRadius: BorderRadius.circular(20).r,
                ),
              ),
              SizedBox(height: 10.h),
          
              // Text description
              AspectRatio(
                aspectRatio: 2.3,
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Text(
                    'Create a Wallet\nEnter the password for the wallet to keep your privacy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Form(
                key:formstate ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text fields
                    BlocProvider(
                      create: (context) => PasswordVisibilityBloc(),
                      child: Column(
                        children: [
                          BlocBuilder<PasswordVisibilityBloc, Map<String, bool>>(
                            builder: (context, state) {
                              return _buildPasswordField(
                                context,
                                controller: passwordController,
                                label: "Password",
                                obscureText: state['signup']!,
                                toggleVisibilityEvent: ToggleSignupPasswordVisibility(),
                              );
                            },
                          ),
                          SizedBox(height: 27.h),
                          BlocBuilder<PasswordVisibilityBloc, Map<String, bool>>(
                            builder: (context, state) {
                              return _buildPasswordField(
                                context,
                                controller: confirmPasswordController,
                                label: "Confirm Password",
                                obscureText: state['confirm']!,
                                toggleVisibilityEvent: ToggleConfirmPasswordVisibility(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          
              // Button at the bottom
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 80.h),
                child: ElevatedButton(
                  onPressed: () {
                    if(formstate.currentState!.validate()== true){
                      create_wallet(passwordController.text, confirmPasswordController.text, context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16.0.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0).r,
                    ),
                    elevation: 5,
                  ),
                  child: Center(
                    child: Text(
                      'Create Wallet',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              TextButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder:
                (context) {
                  return Packages();
                },));
              }, child: Center(child: Text("Skip for now",style: TextStyle(color: Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),),))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required bool obscureText,
        required PasswordVisibilityEvent toggleVisibilityEvent,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0).h,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.w),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.teal),
            prefixIcon: Icon(Icons.lock, color: Colors.teal),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.teal,
              ),
              onPressed: () {
                context.read<PasswordVisibilityBloc>().add(toggleVisibilityEvent);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0).r,
              borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
              borderRadius: BorderRadius.circular(25.0).r,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
              borderRadius: BorderRadius.circular(25.0).r,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 12.0.w),
          ),
          obscureText: obscureText,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field must be filled";
            }
            if (label == "Confirm Password" && value != passwordController.text) {
              return "Passwords do not match";
            }
            if (label == "Password" && value.length < 8) {
              return "The password must be at least 8 characters";
            }
            return null;
          },
        ),
      ),
    );
  }
}
