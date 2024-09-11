import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:comeback/main.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/airport.dart';
import '../../models/company.dart';
import '../../models/flight/bloc/flight_bloc.dart';
import '../../models/flight/flight.dart';
import 'allcompaies.dart';

class bookingflights extends StatefulWidget {
  const bookingflights({super.key});

  @override
  State<bookingflights> createState() => _bookingflightsState();
}

class _bookingflightsState extends State<bookingflights> {
  // String _tripType = 'Round Trip';
  final _formKey = GlobalKey<FormState>();
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _returnDateController = TextEditingController();
  final _passengersAdultsController = TextEditingController();
  final _passengersChildrenController = TextEditingController();
  final _classController = TextEditingController();
  final _companyController = TextEditingController();
  DateTime? pickedDeparture;
  DateTime? pickedReturn;

  final List<String> _dropdowmitems = ['First class', 'Economy'];
  late Airport? fromAirport;
  late Airport? toAirport;
  late Company? company;
  String dropdownvalue = "First class";
  late bool isLoading;

  @override
  void initState() {
    fromAirport = null;
    toAirport = null;
    company = null;
    isLoading = false;
    context.read<FlightBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _departureDateController.dispose();
    _returnDateController.dispose();
    _passengersAdultsController.dispose();
    _passengersChildrenController.dispose();
    _classController.dispose();
    super.dispose();
  }

  Future<List<Flight>> _searchFlights(
      int startAirportId,
      int endAirportId,
      int? companyId,
      String adultsNumber,
      String childrenNum,
      int classId,
      DateTime departureDate,
      DateTime? returnDate) async {
    Dio dio = Dio();
    print("object");
    FormData data = FormData.fromMap({
      "start_airport_id": startAirportId,
      "end_airport_id": endAirportId,
      "adults_number": adultsNumber,
      "children_number": childrenNum,
      "class_id": classId,
      "departure_date": departureDate.toString(),
      if (returnDate != null) "return_date": returnDate.toString(),
      "company_id": companyId
    });
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.post(baseurl+"api/flights/search",
          options: Options(headers: {
            "Authorization":
                "Bearer $token",
            "Accept": "application/json",
          }),
          data: data);
      if (r.data != null) {
        List<dynamic> temp = r.data["data"]["flights"];
        List<Flight> allFlights = temp.map((e) => Flight.fromJson(e)).toList();
        
        setState(() {
          isLoading = false;
        });
        return allFlights;
      } else {
        setState(() {
          isLoading = false;
        });
        
        Fluttertoast.showToast(msg: r.statusMessage ?? 'Error');
        throw "Error";
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  bool firstswitchvalue = false;

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
      body: BlocBuilder<FlightBloc, FlightState>(builder: (context, state) {
        if (state is FlightInitial) {
          context.read<FlightBloc>().add(GetFlightEvent());
          return const SizedBox();
        }
        if (state is FlightLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FlightLoadedState) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
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
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(80))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(80)),
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
                          child: Row(
                            children: [
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Text(
                                    '   Book Your',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(213, 255, 255, 255),
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
                                  Text(
                                    'Flight !',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(213, 255, 255, 255),
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
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 40,
                                ),
                                child: Container(
                                  height: 200,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'images/airplane4.png',
                                          ))),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 221, 226, 225)
                                  .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton<Airport>(
                              value: fromAirport,
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                textBaseline: TextBaseline.alphabetic,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onChanged: (Airport? newValue) {
                                setState(() {
                                  fromAirport = newValue!;
                                });
                              },
                              items: [
                                ...state.airports.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 45,
                          width: 350,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 221, 226, 225)
                                  .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton<Airport?>(
                              value: toAirport,
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              onChanged: (Airport? newValue) {
                                setState(() {
                                  toAirport = newValue!;
                                });
                              },
                              items: [
                                ...state.airports.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 45,
                            width: 350,
                            decoration: BoxDecoration(
                                // color: Colors.white54,
                                color: const Color.fromARGB(255, 221, 226, 225)
                                    .withOpacity(0.9),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              controller: _departureDateController,
                              decoration: InputDecoration(
                                // filled: true,
                                fillColor: Colors.black54,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                errorStyle: TextStyle(
                                  color: Colors.pink,
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        blurRadius: 5),
                                  ],
                                ),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                // labelText: 'From',
                                prefixIcon: const Icon(Icons.date_range),
                                label: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color:
                                        const Color.fromARGB(0, 255, 255, 255),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Text(
                                      ' Depart ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                floatingLabelStyle: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontWeight: FontWeight.w500),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 187, 200, 197),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 0),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.5),
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 0),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.5),
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 1.5),
                                    borderRadius: BorderRadius.circular(25),
                                    gapPadding: 0),
                                prefixIconColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return Colors.teal;
                                  }
                                  return Colors.teal.withOpacity(0.4);
                                }),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                pickedDeparture = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDeparture != null) {
                                  setState(() {
                                    _departureDateController.text =
                                        "${pickedDeparture!.day} ${pickedDeparture!.month} ${pickedDeparture!.year}";
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a depart date';
                                }
                                return null;
                              },
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedToggleSwitch<bool>.size(
                          current: firstswitchvalue,
                          values: const [false, true],
                          iconOpacity: 0.2,
                          indicatorSize: const Size.fromWidth(150),
                          customIconBuilder: (context, local, global) => Text(
                            local.value ? 'Oneway' : 'Round Trip',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.lerp(Colors.black, Colors.teal,
                                    local.animationValue)),
                          ),
                          borderWidth: 0.5,
                          iconAnimationType: AnimationType.onHover,
                          style: ToggleStyle(
                              indicatorColor: Colors.teal.withOpacity(0.5),
                              borderColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          selectedIconScale: 1.0,
                          onChanged: (value) =>
                              setState(() => firstswitchvalue = value),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!firstswitchvalue)
                          Container(
                              height: 45,
                              width: 350,
                              decoration: BoxDecoration(
                                  // color: Colors.white54,
                                  color:
                                      const Color.fromARGB(255, 221, 226, 225)
                                          .withOpacity(0.9),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: TextFormField(
                                cursorColor: Colors.grey,
                                controller: _returnDateController,
                                decoration: InputDecoration(
                                  // filled: true,
                                  fillColor: Colors.black54,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  errorStyle: TextStyle(
                                    color: Colors.pink,
                                    shadows: [
                                      Shadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          blurRadius: 5),
                                    ],
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  // labelText: 'From',
                                  prefixIcon: const Icon(Icons.date_range),
                                  label: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color.fromARGB(
                                          0, 255, 255, 255),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Text(
                                        ' Return ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  floatingLabelStyle: const TextStyle(
                                      color: Colors.tealAccent,
                                      fontWeight: FontWeight.w500),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 187, 200, 197),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 0),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 0),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                      gapPadding: 0),
                                  prefixIconColor:
                                      MaterialStateColor.resolveWith(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.focused)) {
                                      return Colors.teal;
                                    }
                                    return Colors.teal.withOpacity(0.4);
                                  }),
                                ),
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  pickedReturn = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedReturn != null) {
                                    setState(() {
                                      _returnDateController.text =
                                          "${pickedReturn!.day} ${pickedReturn!.month} ${pickedReturn!.year}";
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a return date';
                                  }
                                  return null;
                                },
                              )),
                        const SizedBox(
                          width: 5,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 250, top: 16),
                          child: Text(
                            'passengers',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 10),
                          child: Row(
                            children: [
                              Container(
                                  height: 45,
                                  width: 170,
                                  decoration: BoxDecoration(
                                      // color: Colors.white54,
                                      color: const Color.fromARGB(
                                              255, 221, 226, 225)
                                          .withOpacity(0.9),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30))),
                                  child: TextFormField(
                                    cursorColor: Colors.grey,
                                    controller: _passengersAdultsController,
                                    decoration: InputDecoration(
                                      // filled: true,
                                      fillColor: Colors.black54,
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      errorStyle: TextStyle(
                                        color: Colors.pink,
                                        shadows: [
                                          Shadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              blurRadius: 5),
                                        ],
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))),
                                      // labelText: 'From',
                                      prefixIcon: const Icon(Icons.people),
                                      label: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: const Color.fromARGB(
                                              0, 255, 255, 255),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: Text(
                                            ' Adults ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      floatingLabelStyle: const TextStyle(
                                          color: Colors.tealAccent,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 187, 200, 197),
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      prefixIconColor:
                                          MaterialStateColor.resolveWith(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
                                          return Colors.teal;
                                        }
                                        return Colors.teal.withOpacity(0.4);
                                      }),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter adults number';
                                      }
                                      return null;
                                    },
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  height: 45,
                                  width: 160,
                                  decoration: BoxDecoration(
                                      // color: Colors.white54,
                                      color: const Color.fromARGB(
                                              255, 221, 226, 225)
                                          .withOpacity(0.9),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30))),
                                  child: TextFormField(
                                    cursorColor: Colors.grey,
                                    controller: _passengersChildrenController,
                                    decoration: InputDecoration(
                                      // filled: true,
                                      fillColor: Colors.black54,
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      errorStyle: TextStyle(
                                        color: Colors.pink,
                                        shadows: [
                                          Shadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              blurRadius: 5),
                                        ],
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))),
                                      // labelText: 'From',
                                      prefixIcon: const Icon(Icons.child_care),
                                      label: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: const Color.fromARGB(
                                              0, 255, 255, 255),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: Text(
                                            ' children ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      floatingLabelStyle: const TextStyle(
                                          color: Colors.tealAccent,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 187, 200, 197),
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gapPadding: 0),
                                      prefixIconColor:
                                          MaterialStateColor.resolveWith(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
                                          return Colors.teal;
                                        }
                                        return Colors.teal.withOpacity(0.4);
                                      }),
                                    ),
                                    keyboardType: TextInputType.number,
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Please enter children number';
                                    //   }
                                    //   return null;
                                    // },
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 45,
                                width: 170,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 221, 226, 225)
                                            .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: DropdownButton<String>(
                                    value: dropdownvalue,
                                    style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                    items: [
                                      ..._dropdowmitems.map((e) =>
                                          DropdownMenuItem(
                                              value: e, child: Text(e)))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 45,
                                width: 165,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 221, 226, 225)
                                            .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: DropdownButton<Company?>(
                                    value: company,
                                    style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    onChanged: (Company? newValue) {
                                      setState(() {
                                        company = newValue!;
                                      });
                                    },
                                    items: [
                                      ...state.companies.map((e) =>
                                          DropdownMenuItem(
                                              value: e,
                                              child: Text(e.name ?? "")))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ////////////////////////////////////////////////////////////////////////////

                        const SizedBox(
                          height: 30,
                        ),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    try {
                                      List<Flight> allFlights =
                                          await _searchFlights(
                                              fromAirport!.id!,
                                              toAirport!.id!,
                                              company?.id,
                                              _passengersAdultsController.text,
                                              _passengersChildrenController
                                                  .text,
                                              _dropdowmitems
                                                      .indexOf(dropdownvalue) +
                                                  1,
                                              pickedDeparture!,
                                              pickedReturn);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => alltickets(
                                                    allFlights: allFlights,
                                                    adultsNum:
                                                        _passengersAdultsController
                                                            .text,
                                                    childrenNum:
                                                        _passengersChildrenController
                                                            .text,
                                                  )));
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.5, 0.5),
                                            blurRadius: 13,
                                            blurStyle: BlurStyle.normal)
                                      ],
                                      color: Colors.teal.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is FlightLoadingFailedState) {
          Fluttertoast.showToast(msg: state.errorMessage);
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
