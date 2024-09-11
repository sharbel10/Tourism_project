import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/Auth/Forget_password.dart';
import 'package:comeback/Auth/Snackbar.dart';
import 'package:comeback/Auth/Verification_code.dart';
import 'package:comeback/Localization/AppLocalizations.dart';
import 'package:comeback/Packages/Packages.dart';
import 'package:comeback/Auth/Signup.dart';
import 'package:comeback/main.dart';
import 'package:comeback/passwordbloc/PasswordVisibility_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/Snackbar.dart';
import '../services/login_signup_methods.dart';

class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate2 = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formstate2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //الصورة يلي فوق
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      image: DecorationImage(
                        image: AssetImage('images/newback.jpg'),
                        fit: BoxFit.cover,
                      )),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            AppLocalizations.of(context)!
                                .translate("welcome back"),
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat')),
                        Text(
                          AppLocalizations.of(context)!
                              .translate("login to your account"),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )),
                ),
              ),
              //حقل الايميل
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                   width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      // border:OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(20),
                      //     borderSide: BorderSide(color: Colors.red,width: 20)
                      // ) ,
                      hintStyle:
                          TextStyle(color: Color(0xff05a4a5), fontSize: 20),
                      labelText:
                          AppLocalizations.of(context)!.translate("email"),
                      labelStyle: TextStyle(
                          color: Color(0xff05a4a5),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.mail_lock,
                        size: 25,
                        color: Color(0xff05a4a5),
                      ),
                      fillColor: Color(0xff05a4a5).withOpacity(0.1),
                      filled: true,
                      errorStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20).r,
                          borderSide: BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xff05a4a5).withOpacity(0.7),
                              style: BorderStyle.solid,
                              width: 1.w),
                          borderRadius: BorderRadius.circular(20).r),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20).r,
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        print("objectsssssssssssss");
                        return AppLocalizations.of(context)!
                            .translate("this field must be filled");
                      }
                      if (value!.isEmail) {
                        print("valid");
                      } else {
                        return AppLocalizations.of(context)!
                            .translate("the input must be an email");
                        print("not valid");
                      }
                    },
                  ),
                ),
              ),
              //حقل كلمة السر
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BlocBuilder<PasswordVisibilityBloc, Map<String, bool>>(
                  builder: (context, state) {
                    return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        obscureText: state['login']!,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          // border:OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(20),
                          //     borderSide: BorderSide(color: Colors.red,width: 20)
                          // ) ,
                          suffixIcon: GestureDetector(
                            child: Icon(
                                state['login']!
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 26,
                                color: Color(0xff05a4a5)),
                            onTap: () {
                              print("object");
                              BlocProvider.of<PasswordVisibilityBloc>(context)
                                  .add(ToggleLoginPasswordVisibility());
                            },
                          ),
                          hintStyle:
                              TextStyle(color: Color(0xff05a4a5), fontSize: 20),
                          labelText: AppLocalizations.of(context)!
                              .translate("password"),
                          labelStyle: TextStyle(
                              color: Color(0xff05a4a5),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 25,
                            color: Color(0xff05a4a5),
                          ),
                          fillColor: Color(0xff05a4a5).withOpacity(0.1),
                          filled: true,
                          errorStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff05a4a5).withOpacity(0.7),
                                  style: BorderStyle.solid,
                                  width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                        keyboardType: TextInputType.text,
                        controller: password,
                        // onChanged: (value) {
                        //   value!=email;
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            print("objectsssssssssssss");
                            return AppLocalizations.of(context)!
                                .translate("this field must be filled");
                          }
                          if (value!.length! >= 8) {
                            print("valid");
                          } else {
                            return AppLocalizations.of(context)!.translate(
                                "the password must be more than 8 characters");
                            print("not valid");
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return ForgotPasswordPage();
                       },));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("forget password"),
                          style: TextStyle(
                            fontSize: 15.sp,
                              color: Color(0xff05a4a5),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (formstate2.currentState!.validate()) {
                         login(email.text, password.text, context);
                      } else {
                        print("poooo");
                      }

                      // Navigator.push( context,MaterialPageRoute(builder: (context) {
                      //   return SettingsPage();
                      // }));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: Color(0xff05a4a5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.translate("login"),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      loginInWithGoogle(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Color(0xff05a4a5),
                              style: BorderStyle.solid,
                              width: 2)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Image(
                              image: AssetImage('images/google.png'),
                              repeat: ImageRepeat.noRepeat,
                              fit: BoxFit.cover,
                              width: 30,
                            ),
                          ),
                          Text(
                            "Login with Google",
                            style: TextStyle(
                                color: Color(0xff05a4a5),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate("didn't have an account?"),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return Signup();
                        },
                      ));
                    },
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context)!.translate("signup"),
                        style: TextStyle(
                            color: Color(0xff05a4a5),
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff05a4a5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
