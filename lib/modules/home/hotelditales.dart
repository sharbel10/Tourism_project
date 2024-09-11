import 'package:comeback/main.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hotel/bloc/hotel_details_bloc.dart';
import '../../models/hotel/hotel_repository.dart';

class hotelditales extends StatefulWidget {
  const hotelditales({super.key, required this.hotelId});
  final int hotelId;
  @override
  State<hotelditales> createState() => _hotelditalesState();
}

class _hotelditalesState extends State<hotelditales> {
  final _numberofrooms = TextEditingController();
  final _nomecontroller = TextEditingController();
  final _endstaycationcontroller = TextEditingController();
  final _startstaycationcontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _walletpasswordcontroller = TextEditingController();

  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }
  Future<void> makeReservation() async {
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      "hotel_id": widget.hotelId,
      "number_of_rooms": _numberofrooms.text,
      "staying_date": _startstaycationcontroller.text,
      "departure_date": _endstaycationcontroller.text,
      "name": _nomecontroller.text,
      "email": _emailcontroller.text,
      "wallet_password": _walletpasswordcontroller.text,
    });
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r =
          await dio.post(baseurl+"api/add/hotel/transaction",
              options: Options(headers: {
                "Authorization":
                    "Bearer $token",
                "Accept": "application/json",
              }),
              data: data);
      if (r.statusCode == 200) {
        print('success');
        Fluttertoast.showToast(msg: r.data["message"] ?? 'done');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).popAndPushNamed("/homepage");
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: r.statusMessage ?? 'Error');
        print('farsh');
        throw "Error";
      }
    }
     on DioException catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HotelRepository(),
      child: BlocProvider(
        create: (context) => HotelDetailsBloc(
          hotelRepository: context.read<HotelRepository>(),
        ),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              // toolbarHeight: 0,
              // elevation: 0.0,
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
                          color: Colors.grey.withOpacity(0.4)),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black45, size: 30)),
                ),
              ),
            ),
            body: BlocBuilder<HotelDetailsBloc, HotelDetailsState>(
                builder: (context, state) {
              if (state is HotelDetailsInitial) {
                context
                    .read<HotelDetailsBloc>()
                    .add(GetHotelDetailsEvent(id: widget.hotelId));
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HotelDetailsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HotelDetailsLoadedState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: state.details.imagePaths != null
                              ? [
                                  // ...state.details.imagePaths!.map((i) => Container(
                                  //   decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //           image: NetworkImage(i), fit: BoxFit.cover),
                                  //       borderRadius: const BorderRadius.only(
                                  //           bottomRight: Radius.circular(30),
                                  //           bottomLeft: Radius.circular(30)),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           color: Colors.grey.withOpacity(1),
                                  //           offset: const Offset(0.5, 0.5),
                                  //           blurRadius: 13,
                                  //           spreadRadius: 1,
                                  //           blurStyle: BlurStyle.normal,
                                  //         )
                                  //       ]),
                                  // ),),
                                  ...state.details.imagePaths!.map((i) =>
                                      Container(
                                          clipBehavior: Clip.hardEdge,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(30),
                                                      bottomLeft:
                                                          Radius.circular(30)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(1),
                                                  offset:
                                                      const Offset(0.5, 0.5),
                                                  blurRadius: 13,
                                                  spreadRadius: 1,
                                                  blurStyle: BlurStyle.normal,
                                                )
                                              ]),
                                          child: Image.network(i))),
                                ]
                              : [],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${state.details.name}',
                                    style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${state.details.stars}',
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/pin (1).png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  Text(
                                    '${state.details.region?.country?.name}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Facilities',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Row(
                                children: state.details.privileges != null
                                    ? [
                                        ...state.details.privileges!.map((e) =>
                                            Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.grey),
                                                child: Icon(
                                                    e.name == "Free Breakfast"
                                                        ? Icons.free_breakfast
                                                        : Icons.wifi)
                                                // Text('wi_fi',style: TextStyle(fontWeight: FontWeight.bold),),
                                                )),
                                      ]
                                    : [],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Description \n ${state.details.description}',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              content: Container(
                                                height: 600.h,
                                                width: 300.w,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'hotel name',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _numberofrooms,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' room number',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter the number of rooms';
                                                              }
                                                              return null;
                                                            },
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _nomecontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' Your Name',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your name';
                                                              }
                                                              return null;
                                                            },
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _startstaycationcontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                              // labelText: 'From',
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' Depart ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              DateTime? picked =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime(
                                                                        2101),
                                                              );
                                                              if (picked !=
                                                                  null) {
                                                                setState(() {
                                                                  _startstaycationcontroller
                                                                          .text =
                                                                      "${picked.day} ${picked.month} ${picked.year}";
                                                                });
                                                              }
                                                            },
                                                            // validator: (value) {
                                                            //   if (value ==
                                                            //           null ||
                                                            //       value
                                                            //           .isEmpty) {
                                                            //     return 'Please enter a depart date';
                                                            //   }
                                                            //   return null;
                                                            // },
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _endstaycationcontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                              // labelText: 'From',
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' End ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              DateTime? picked =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime(
                                                                        2101),
                                                              );
                                                              if (picked !=
                                                                  null) {
                                                                setState(() {
                                                                  _endstaycationcontroller
                                                                          .text =
                                                                      "${picked.day} ${picked.month} ${picked.year}";
                                                                });
                                                              }
                                                            },
                                                            // validator: (value) {
                                                            //   if (value ==
                                                            //           null ||
                                                            //       value
                                                            //           .isEmpty) {
                                                            //     return 'Please enter a depart date';
                                                            //   }
                                                            //   return null;
                                                            // },
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _emailcontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' Email',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your Email';
                                                              }
                                                              return null;
                                                            },
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          height: 45,
                                                          width: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.white54,
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          226,
                                                                          225)
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.grey,
                                                            controller:
                                                                _walletpasswordcontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              // filled: true,
                                                              fillColor: Colors
                                                                  .black54,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              errorStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                shadows: [
                                                                  Shadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6),
                                                                      blurRadius:
                                                                          5),
                                                                ],
                                                              ),
                                                              errorBorder:
                                                                  const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(25))),
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              25))),
                                                  
                                                              label: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                                  child: Text(
                                                                    ' Wallet password',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .teal,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              floatingLabelStyle: const TextStyle(
                                                                  color: Colors
                                                                      .tealAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          187,
                                                                          200,
                                                                          197),
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              border: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gapPadding:
                                                                      0),
                                                              prefixIconColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .focused)) {
                                                                  return Colors
                                                                      .teal;
                                                                }
                                                                return Colors
                                                                    .teal
                                                                    .withOpacity(
                                                                        0.4);
                                                              }),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter the number of rooms';
                                                              }
                                                              return null;
                                                            },
                                                          )),
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                      isLoading
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                try {
                                                                  makeReservation();
                                                                } catch (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg: e
                                                                              .toString());
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50,
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    color: Colors
                                                                        .tealAccent),
                                                                child: Text(
                                                                  'confirm reservation',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        'P.s:\nYour resirvaition will be canceled if you do not pay within 24 hour',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .pink.shade400,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.tealAccent,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset:
                                                    Offset.fromDirection(0.3),
                                                blurRadius: 0.5,
                                                blurStyle: BlurStyle.normal)
                                          ]),
                                      child: Text(
                                        '${state.details.roomPrice}\$',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is HotelDetailsLoadingFailedState) {
                Fluttertoast.showToast(msg: state.errorMessage);
                return const SizedBox();
              } else {
                return const SizedBox();
              }
            })),
      ),
    );
  }
}
