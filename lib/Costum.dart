// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'Localization/AppLocalizations.dart';
//
// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final IconData prefixIcon;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final bool isOptional;
//   final FormFieldValidator<String>? validator;
//   final Widget? suffixIcon; // Add this line
//
//   CustomTextField({
//     required this.controller,
//     required this.labelText,
//     required this.prefixIcon,
//     required this.keyboardType,
//     required this.obscureText,
//     required this.isOptional,
//     this.validator,
//     this.suffixIcon, // Add this line
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         prefixIcon: Icon(prefixIcon),
//         suffixIcon: suffixIcon, // Add this line
//       ),
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       validator: validator,
//     );
//   }
// }
//
// //customElevatedButton
//
// Widget customElevatedButton({
//   required VoidCallback onPressed,
//   required String text,
// }) {
//   return Padding(
//     padding: EdgeInsets.all(12.w),
//     child: Container(
//       width: 0.9.sw,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xff05a4a5),
//           padding: EdgeInsets.symmetric(vertical: 15.h),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
//
//
// Widget customHeader(BuildContext context) {
//   return Container(
//     margin: EdgeInsets.only(bottom: 10.h),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: 20.h, left: 12.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 AppLocalizations.of(context)!.translate("Travel Easier"),
//                 style: TextStyle(
//                   color: Color(0xff05a4a5),
//                   fontSize: 30.sp,
//                   fontFamily: 'Montserrat',
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 AppLocalizations.of(context)!.translate("With us"),
//                 style: TextStyle(
//                   color: Color(0xff05a4a5),
//                   fontSize: 30.sp,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(bottom: 20.h),
//           height: 150.h,
//           width: 150.w,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("images/NicePng_airoplane-png_2545928-removebg-preview.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
//
