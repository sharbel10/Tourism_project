import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import '../services/login_signup_methods.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:comeback/Auth/Verification_code.dart';
import 'package:comeback/Localization/AppLocalizations.dart';
import 'package:comeback/Auth/Login.dart';
import 'package:comeback/passwordbloc/PasswordVisibility_bloc.dart';

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController confirmpassword = TextEditingController();
TextEditingController birthdate = TextEditingController();
TextEditingController phone = TextEditingController();
GlobalKey<FormState> formstate = GlobalKey();
GlobalKey<FormState> phone_number_state = GlobalKey();

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  // Section for image and text
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20.h, left: 12.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("Travel Easier"),
                                style: TextStyle(
                                  color:Color(0xff05a4a5),
                                  fontSize: 30.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                AppLocalizations.of(context)!.translate("With us"),
                                style: TextStyle(
                                  color: Color(0xff05a4a5),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          height: 150.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/NicePng_airoplane-png_2545928-removebg-preview.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("Register"),
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4896a1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      AppLocalizations.of(context)!.translate("create your new account"),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  // Full Name Field
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
                    child: Container(
                      width: 0.9.sw,
                      child: IntrinsicHeight(
                        child: TextFormField(
                          controller: name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xff05a4a5), fontSize: 20.sp),
                            labelText: AppLocalizations.of(context)!.translate("full name"),
                            labelStyle: TextStyle(
                              color:  Color(0xff05a4a5),
                              //Colors.teal,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(Icons.person_sharp, size: 25.sp, color: Color(0xff05a4a5)
                            ),
                            fillColor: Color(0xff05a4a5).withOpacity(0.1),
                            filled: true,
                            errorStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff05a4a5).withOpacity(0.7), style: BorderStyle.solid, width: 1.w),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 19.0.h, horizontal: 10.0.w), // Adjust content padding
                          ),
                          cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.translate("this field must be filled");
                            }
                            if (value.isNum) {
                              return AppLocalizations.of(context)!.translate("the input must be a name");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  // Phone Number Field
                  Form(
                    key: phone_number_state ,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Container(
                        width: 0.9.sw,
                        child: IntrinsicHeight(
                          child: TextFormField(
                         //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color:Colors.teal,
                              //Color(0xff05a4a5),
                                  fontSize: 20.sp),
                              labelText: 'phone number (optional)',
                              labelStyle: TextStyle(
                                color: //Colors.teal
                                 Color(0xff05a4a5),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.mobile_screen_share, size: 25.sp, color: Color(0xff05a4a5)
                              ),
                              fillColor: Color(0xff05a4a5).withOpacity(0.1),
                              filled: true,
                              errorStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff05a4a5).withOpacity(0.7), style: BorderStyle.solid, width: 1.w),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 19.0.h, horizontal: 10.0.w),
                            ),
                            cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                            keyboardType: TextInputType.phone,
                            controller: phone,
                            validator: (value) {
                              if (value!.length < 10 || value.length > 15) {
                                return "the phone number must be between [10,15]";
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Email Field
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      width: 0.9.sw,
                      child: TextFormField(
                        controller: email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Color(0xff05a4a5), fontSize: 20.sp),
                          labelText: AppLocalizations.of(context)!.translate("email"),
                          labelStyle: TextStyle(
                            color: Color(0xff05a4a5),
                            //Colors.teal,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(Icons.mail_lock, size: 25.sp, color: Color(0xff05a4a5)
                          ),
                          fillColor: Color(0xff05a4a5).withOpacity(0.1),
                          filled: true,
                          errorStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff05a4a5).withOpacity(0.7), style: BorderStyle.solid, width: 1.w),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 19.0.h, horizontal: 10.0.w),
                        ),
                        cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.translate("this field must be filled");
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return AppLocalizations.of(context)!.translate("the input must be an email");
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  // Password Field
                  BlocBuilder<PasswordVisibilityBloc, Map<String, bool>>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Container(
                          width: 0.9.sw,
                          child: TextFormField(
                            controller: password,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: state['signup']!,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color(0xff05a4a5), fontSize: 20.sp),
                              labelText: AppLocalizations.of(context)!.translate("password"),
                              labelStyle: TextStyle(
                                color:Color(0xff05a4a5),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.lock, size: 25.sp, color: Color(0xff05a4a5)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state['signup']! ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xff05a4a5),
                                ),
                                onPressed: () {
                                  BlocProvider.of<PasswordVisibilityBloc>(context).add(ToggleSignupPasswordVisibility());
                                },
                              ),
                              fillColor: Color(0xff05a4a5).withOpacity(0.1),
                              filled: true,
                              errorStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff05a4a5).withOpacity(0.7), style: BorderStyle.solid, width: 1.w),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 19.0.h, horizontal: 10.0.w),
                            ),
                            cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate("this field must be filled");
                              }
                              if (value.length < 6) {
                                return AppLocalizations.of(context)!.translate("password too short");
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  // Confirm Password Field
                  BlocBuilder<PasswordVisibilityBloc, Map<String, bool>>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Container(
                          width: 0.9.sw,
                          child: TextFormField(
                            controller: confirmpassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: state['confirm']!,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.teal
                            //  Color(0xff05a4a5)
                                  , fontSize: 20.sp),
                              labelText: AppLocalizations.of(context)!.translate("Confirm password"),
                              labelStyle: TextStyle(
                                color: Color(0xff05a4a5),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.lock, size: 25.sp, color: Color(0xff05a4a5)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state['confirm']! ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xff05a4a5),
                                ),
                                onPressed: () {
                                  BlocProvider.of<PasswordVisibilityBloc>(context).add(ToggleConfirmPasswordVisibility());
                                },
                              ),
                              fillColor: Color(0xff05a4a5).withOpacity(0.1),
                              filled: true,
                              errorStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff05a4a5).withOpacity(0.7), style: BorderStyle.solid, width: 1.w),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 19.0.h, horizontal: 10.0.w),
                            ),
                            cursorColor: Color(0xff05a4a5).withOpacity(0.6),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate("this field must be filled");
                              }
                              if (value != password.text) {
                                return AppLocalizations.of(context)!.translate("passwords do not match");
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30,horizontal:10 ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if(formstate.currentState!.validate()){
                            print("fadi");
                            signup(name.text, email.text, password.text, confirmpassword.text,phone.text,context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.86,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            color: Color(0xff05a4a5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.translate("signup"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.translate( "already have an account"),style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder:
                              (context) {
                            return Login();
                          },));
                        },
                        child: Container(
                            child: Text(AppLocalizations.of(context)!.translate("login"),style: TextStyle(color: Color(0xff05a4a5),fontSize: 20, decoration: TextDecoration.underline,decorationColor: Color(0xff05a4a5),fontWeight: FontWeight.bold),)),
                      )
                    ],
                  ),

                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
