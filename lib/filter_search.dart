// import 'package:flutter/material.dart';
// import 'package:your_project/global_state.dart'; // Adjust import as necessary
// import 'Search_package.dart';
// import 'your_search_delegate_file.dart'; // Adjust import as necessary
//
// class PackagesScreen extends StatefulWidget {
//   @override
//   _PackagesScreenState createState() => _PackagesScreenState();
// }
//
// class _PackagesScreenState extends State<PackagesScreen> {
//   // Example filter type setting function
//   void _setPackageType(String type) {
//     GlobalState().currentPackageType = type;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Packages'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GestureDetector(
//             onTap: () {
//               // Example: setting a package type before showing the search delegate
//               _setPackageType('food'); // Replace with the actual selected filter
//
//               showSearch(
//                 context: context,
//                 delegate: CustomSearchDelegate(),
//               );
//             },
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.07,
//               width: MediaQuery.of(context).size.width * 0.86,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.white38,
//                   style: BorderStyle.solid,
//                   width: 2.0,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black38,
//                     offset: Offset(-1, 1),
//                     blurRadius: 1,
//                     blurStyle: BlurStyle.solid,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.search_rounded,
//                       color: Color(0xffbababc),
//                       size: 30,
//                     ),
//                   ),
//                   Text(
//                     "Search a trip by country, place",
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
