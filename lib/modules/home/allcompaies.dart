import 'package:comeback/main.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/flight/flight.dart';

class alltickets extends StatefulWidget {
  const alltickets({super.key,required this.allFlights,required this.adultsNum,required this.childrenNum});
  final List<Flight> allFlights;
  final String? adultsNum;
  final String? childrenNum;

  @override
  State<alltickets> createState() => _allticketsState();
}

class _allticketsState extends State<alltickets> {
  late bool isLoading;
  final _waletcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }


  Future<void> makeReservation(Flight f,) async {
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      "going_id" : f.goingId,
      if(f.returnId != null) "return_id" : f.returnId,
      "adults_number" : widget.adultsNum,
      "children_number" : widget.childrenNum,
      "price" : f.price,
      "wallet_password" : _waletcontroller.text,
      "name" : _namecontroller.text,
      "email" : _emailcontroller.text,
    });
    // print({
    //   "going_id" : f.goingId,
    //   if(f.returnId != null) "return_id" : f.returnId,
    //   "adults_number" : widget.adultsNum,
    //   "children_number" : widget.childrenNum,
    //   "price" : f.price,
    //   "wallet_password" : _waletcontroller.text,
    //   "name" : _namecontroller.text,
    //   "email" : _emailcontroller.text,
    // });
    try{
      setState(() {
        isLoading = true;
        print("seba");
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.post(baseurl+"api/add/flight/transaction",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
            "Accept": "application/json",
          }
      ),data: data);
      print(FormData);
      if(r.statusCode == 200){
        print("object");
        Fluttertoast.showToast(msg: r.data["message"] ?? 'done');
        setState(() {
        isLoading = false;
         print("suiii");
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.statusMessage ?? 'Error occurred')),
      );
      Navigator.of(context).popAndPushNamed("/all flights");
      }
      else{
        print("sharbel");
        setState(() {
        isLoading = false;
      }
      );
      Fluttertoast.showToast(msg: r.statusMessage ?? 'Error');
        throw "Error";
      }
    }on DioException catch (e){
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black45.withOpacity(0.2)),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.black38, size: 30)),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: 220,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.3, 0.3),
                          blurRadius: 9,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.normal,
                        )
                      ],
                      image: DecorationImage(
                          image: AssetImage('images/wordmapdotted.png'),
                          fit: BoxFit.fill),
                      // color: Colors.red,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80))),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.only(bottomLeft: Radius.circular(80)),
                        gradient: LinearGradient(colors: [
                          //  Colors.teal.withOpacity(0.7),
                          Colors.white54.withOpacity(0.9),
                          Colors.teal.withOpacity(0.7),
                        ])),
                  )),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      const Text(
                        '  All companies',
                        style: TextStyle(
                            color: Color.fromARGB(213, 255, 255, 255),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.3, 0.3),
                                blurRadius: 9,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.normal,
                              )
                            ]),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        '           where you find your comfortable Flights',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 72, 49, 49).withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              const BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.3, 0.3),
                                blurRadius: 9,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.normal,
                              )
                            ]),
                      ),
                    
                    ],
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 500,
                    width: double.maxFinite,
                    child: ListView(
                      children: [
                        ...widget.allFlights.map((e) => InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text('make a resrvation '),
                                    content: Container(
                                      height: 500,
                                      width: 400,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              width: double.maxFinite,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 150),
                                                    child: Text(
                                                      'From: ${e.startAirport}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 160),
                                                    child: Text('to: ${e.endAirport}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 50),
                                                    child: Text('Adult number: ${widget.adultsNum}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30),
                                                    child: Text(
                                                        'children number: ${widget.childrenNum}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 100),
                                                    child: Text('price: ${e.price}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                height: 45,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                    // color: Colors.white54,
                                                    color: Color.fromARGB(
                                                            255, 221, 226, 225)
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: TextFormField(
                                                  cursorColor: Colors.grey,
                                                  controller: _waletcontroller,
                                                  decoration: InputDecoration(
                                                    // filled: true,
                                                    fillColor: Colors.black54,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    errorStyle: TextStyle(
                                                      color: Colors.pink,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            blurRadius: 5),
                                                      ],
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    focusedErrorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    // labelText: 'From',
                                                    prefixIcon:
                                                        Icon(Icons.wallet),
                                                    label: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: const Color
                                                            .fromARGB(
                                                            0, 255, 255, 255),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Text(
                                                          ' wallet password ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.teal,
                                                            shadows: const [
                                                              Shadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                            color: Colors
                                                                .tealAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            187,
                                                                            200,
                                                                            197),
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    prefixIconColor:
                                                        MaterialStateColor
                                                            .resolveWith((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .focused)) {
                                                        return Colors.teal;
                                                      }
                                                      return Colors.teal
                                                          .withOpacity(0.4);
                                                    }),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a destination city';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                height: 45,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                    // color: Colors.white54,
                                                    color: Color.fromARGB(
                                                            255, 221, 226, 225)
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: TextFormField(
                                                  cursorColor: Colors.grey,
                                                  controller: _namecontroller,
                                                  decoration: InputDecoration(
                                                    // filled: true,
                                                    fillColor: Colors.black54,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    errorStyle: TextStyle(
                                                      color: Colors.pink,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            blurRadius: 5),
                                                      ],
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    focusedErrorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    // labelText: 'From',
                                                    prefixIcon:
                                                        Icon(Icons.person),
                                                    label: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: const Color
                                                            .fromARGB(
                                                            0, 255, 255, 255),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Text(
                                                          ' Full name ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.teal,
                                                            shadows: const [
                                                              Shadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                            color: Colors
                                                                .tealAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            187,
                                                                            200,
                                                                            197),
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    prefixIconColor:
                                                        MaterialStateColor
                                                            .resolveWith((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .focused)) {
                                                        return Colors.teal;
                                                      }
                                                      return Colors.teal
                                                          .withOpacity(0.4);
                                                    }),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your name';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                height: 45,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                    // color: Colors.white54,
                                                    color: Color.fromARGB(
                                                            255, 221, 226, 225)
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: TextFormField(
                                                  cursorColor: Colors.grey,
                                                  controller: _emailcontroller,
                                                  decoration: InputDecoration(
                                                    // filled: true,
                                                    fillColor: Colors.black54,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    errorStyle: TextStyle(
                                                      color: Colors.pink,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            blurRadius: 5),
                                                      ],
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    focusedErrorBorder:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                    // labelText: 'From',
                                                    prefixIcon:
                                                        Icon(Icons.email),
                                                    label: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: const Color
                                                            .fromARGB(
                                                            0, 255, 255, 255),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Text(
                                                          ' Email ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.teal,
                                                            shadows: const [
                                                              Shadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                            color: Colors
                                                                .tealAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            187,
                                                                            200,
                                                                            197),
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gapPadding: 0),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gapPadding: 0),
                                                    prefixIconColor:
                                                        MaterialStateColor
                                                            .resolveWith((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .focused)) {
                                                        return Colors.teal;
                                                      }
                                                      return Colors.teal
                                                          .withOpacity(0.4);
                                                    }),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your email';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            isLoading ? const Center(child: CircularProgressIndicator(),) : InkWell(
                                              onTap: () async {
                                                try{
                                                      makeReservation(e);
                                                    }catch (e){
                                                 Fluttertoast.showToast(msg: e.toString());
                                                   }
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.teal
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset:
                                                              Offset(0.5, 0.5),
                                                          blurRadius: 13),
                                                    ]),
                                                child: Text(
                                                  'confirm',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              'P.s:\nYour resirvaition will be canceled if you do not pay within 24 hour',
                                              style: TextStyle(
                                                  color: Colors.pink.shade400,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            height: 250,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal.withOpacity(0.5)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, left: 10),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(200)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 30, left: 10),
                                      child: Text(
                                        '${e.goingCompanyName}',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30,right: 170),
                                  child: Text('${e.goingCompanyName}',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),),
                                ),
                          
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('${e.goingDate}:${e.goingTime}',style: TextStyle(color: Colors.black38,fontSize: 16,fontWeight: FontWeight.w700),),
                                )
                              ],
                            ),
                          ),
                        ),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
