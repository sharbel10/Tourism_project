import 'package:comeback/Packages/Packages.dart';
import 'package:comeback/main.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../All_Transactions.dart';
import '../../models/country/bloc/country_bloc.dart';
import '../../models/favorite_list.dart';
import '../../models/hotel/bloc/hotel_bloc.dart';
import 'allcountries.dart';


class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late bool isLoading;
  late bool isAdd;
  late List<FavoriteList> lists;
  late final TextEditingController listNameCtrl;
  late FavoriteList? selectedList;

  @override
  void initState() {
    context.read<CountryBloc>().add(GetCountryEvent());
    context.read<HotelBloc>().add(GetHotelEvent());
    isLoading = false;
    isAdd = false;
    listNameCtrl = TextEditingController();
    lists = [];
    selectedList = null;
    //_getFavoriteList();
    super.initState();
  }

  Future<void> _getFavoriteList() async {
    Dio dio = Dio();
    try{
      setState(() {
        isLoading = true;
      });
      lists.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.get(baseurl+"api/favorite",options: Options(

          headers: {
            "Authorization" : "Bearer $token",
            "Accept": "application/json",
          }
      ),);
      if(r.statusCode ==200 && r.data["data"] != null){
        List<dynamic> temp = r.data["data"]["lists"];
        lists.addAll(temp.map((e) => FavoriteList.fromJson(e)));
        setState(() {
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading = false;
        });
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

  Future<void> _addFavoriteList() async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('login_token');

      Response r = await dio.post(baseurl+"api/favorite",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
            "Accept": "application/json",
          }
      ),data: {
        "name" : listNameCtrl.text
      });
      if(r.statusCode ==200){
        await _getFavoriteList();
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: r.statusMessage ?? 'Error');
        throw "Error";
      }
    }on DioException catch (e){
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
  Future<void> _addToFavorite(String type,int itemId,int listId) async {
    Dio dio = Dio();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('login_token');
      Response r = await dio.post(baseurl+"api/favorite/add/item",options: Options(
          headers: {
            "Authorization" : "Bearer $token",
            "Accept": "application/json",
          }
      ),data: {
        "item_type" : listNameCtrl.text,
        "item_id" : itemId,
        "list_id" : listId
      });
      if(r.statusCode ==200){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Added to favorite successfully!");
      }else{
        Fluttertoast.showToast(msg: r.statusMessage ?? 'Error');
        throw "Error";
      }
    }on DioException catch (e){
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // return ProfileSettingsPage();
          },
          child: const Icon(
            Icons.settings,
            size: 30,
            color: Colors.grey,
          ),
        ),
        actions: [
          const Text(
            'Exploreo',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.blueGrey),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(170, 158, 158, 158),
                      offset: Offset(0.5, 0.5),
                      blurRadius: 13,
                      spreadRadius: 0.5,
                      blurStyle: BlurStyle.normal,
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      'images/location-pin (1).png',
                    ),
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {

              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white70,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(170, 158, 158, 158),
                        offset: Offset(0.5, 0.5),
                        blurRadius: 13,
                        spreadRadius: 0.5,
                        blurStyle: BlurStyle.normal,
                      )
                    ]),
                // child: const Row(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       child: Icon(
                //         Icons.search,
                //         color: Color.fromARGB(229, 158, 158, 158),
                //         size: 30,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 2,
                //     ),
                //     Text(
                //       'Search',
                //       style: TextStyle(
                //           color: Color.fromARGB(228, 158, 158, 158),
                //           fontSize: 17,
                //           fontWeight: FontWeight.w500),
                //     ),
                //   ],
                // ),
              ),
            ),
             SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                   Text(
                    'Recommender Countries',
                    style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                   SizedBox(
                    width: 70.w,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/all countries');
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ),
             SizedBox(
              height: 25.h,
            ),
            Expanded(
              child: BlocBuilder<CountryBloc,CountryState>(
                  builder: (context,state){
                if(state is CountryLoadingState){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(state is CountryLoadedState){
                  return  ListView(
                    shrinkWrap: false,
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...state.countries.map((e) => InkWell(
                        onTap: () {
                          // Navigator.pushNamed(context, '/contry ditales',arguments: e.id);
                          Navigator.of(context).pushNamed('/contry ditales',arguments: e.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 13,
                                    spreadRadius: 1,
                                    blurStyle: BlurStyle.normal,
                                  )
                                ],
                                // color: Colors.teal,
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                    image: AssetImage(
                                      'images/s6.jpg',
                                    ),
                                    fit: BoxFit.fill)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white24.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(20).r),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${e.name}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                            const Text(
                                              'description',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (context){
                                                FavoriteList? selected;
                                                return StatefulBuilder(builder: (sfContext,sfSetState){return AlertDialog(
                                                  title: const Text("Add To Favorite"),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      isLoading ? const Center(child: CircularProgressIndicator(),) : DropdownButton<FavoriteList?>(value: selected,items: [
                                                        ...lists.map((l) => DropdownMenuItem(value: l,child: Text(l.name ?? ""),),),
                                                      ], onChanged: (FavoriteList? value) {
                                                        if(value != null){
                                                          sfSetState(() {
                                                            selected = value;
                                                          });
                                                        }
                                                      },),
                                                      TextButton.icon(onPressed: (){
                                                        showDialog(context: context, builder: (context) => AlertDialog(
                                                          title: const Text("New Favorite List"),
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                  height: 45,
                                                                  width: 350,
                                                                  decoration: BoxDecoration(
                                                                    // color: Colors.white54,
                                                                      color: const Color.fromARGB(255, 221, 226, 225)
                                                                          .withOpacity(0.9),
                                                                      borderRadius:
                                                                      const BorderRadius.all(Radius.circular(30))),
                                                                  child: TextFormField(
                                                                    cursorColor: Colors.grey,
                                                                    controller: listNameCtrl,
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
                                                                          color: const Color.fromARGB(
                                                                              0, 255, 255, 255),
                                                                        ),
                                                                        child: const Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 4, horizontal: 8),
                                                                          child: Text(
                                                                            ' List Name ',
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
                                                                              color: Colors.transparent, width: 1.5),
                                                                          borderRadius: BorderRadius.circular(25),
                                                                          gapPadding: 0),
                                                                      prefixIconColor: MaterialStateColor.resolveWith(
                                                                              (Set<MaterialState> states) {
                                                                            if (states.contains(
                                                                                MaterialState.focused)) {
                                                                              return Colors.teal;
                                                                            }
                                                                            return Colors.teal.withOpacity(0.4);
                                                                          }),
                                                                    ),
                                                                  )),
                                                              FilledButton(onPressed: (){
                                                                //_addFavoriteList();
                                                              }, child: Text("Save",),),
                                                            ],
                                                          ),
                                                        ));
                                                      }, label: Text("Create Favorite List"),icon: Icon(Icons.add_circle_outline),),
                                                      FilledButton(onPressed: (){
                                                        try{
                                                          //_addToFavorite("regions", e.id!, selected!.id!);
                                                        }catch (e){
                                                          Fluttertoast.showToast(msg: e.toString());
                                                        }
                                                      }, child: Text("Add to favorite"))

                                                    ],
                                                  ),
                                                );});
                                              });
                                            },
                                            icon: const Icon(Icons.favorite_border),
                                            alignment: Alignment.bottomRight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  );
                }else if(state is CountryEmptyState){
                  return const Center(
                    child: Text("There is no recommended countries"),
                  );
                }else if(state is CountryLoadingFailedState){
                  Fluttertoast.showToast(msg: state.errorMessage);
                  return const SizedBox();
                }else{
                  return const SizedBox();
                }
              }),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  const Text(
                    'Hotels',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(
                    width: 235,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/all hotels');
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ),

            // ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 190,
                width: double.maxFinite,
                child: BlocBuilder<HotelBloc,HotelState>(
                  builder: (context,state) {
                    if(state is HotelLoadingState){
                      return const Center(child: CircularProgressIndicator(),);
                    }else if(state is HotelLoadedState){
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...state.homeHotels.map((e) => InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/hotel ditales',arguments: e.id);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: 250,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          image: NetworkImage(e.imagePath ?? ""),
                                          fit: BoxFit.cover),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          offset: const Offset(0.5, 0.5),
                                          blurRadius: 13,
                                          spreadRadius: 1,
                                          blurStyle: BlurStyle.normal,
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: double.maxFinite,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(

                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                       top: 8, left: 15),
                                                  child: Text(
                                                    '${e.name}',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87
                                                            .withOpacity(0.7)),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${e.stars}',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow.withOpacity(1),
                                                      size: 18,
                                                      shadows: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(0.5),
                                                            offset:
                                                            Offset.fromDirection(10),
                                                            blurRadius: 1,
                                                            blurStyle: BlurStyle.normal)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.pin_drop_rounded,
                                                    color: Colors.teal.withOpacity(0.5),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    '${e.region?.country?.name}',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    width: 100,
                                                  ),
                                                  Text(
                                                    '${e.roomPrice}\$',
                                                    style:
                                                    const TextStyle(color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (context){
                                      FavoriteList? selected;
                                      return StatefulBuilder(builder: (sfContext,sfSetState){return AlertDialog(
                                        title: const Text("Add To Favorite"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            isLoading ? const Center(child: CircularProgressIndicator(),) : DropdownButton<FavoriteList?>(value: selected,items: [
                                              ...lists.map((l) => DropdownMenuItem(value: l,child: Text(l.name ?? ""),),),
                                            ], onChanged: (FavoriteList? value) {
                                              if(value != null){
                                                sfSetState(() {
                                                  selected = value;
                                                });
                                              }
                                            },),
                                            TextButton.icon(onPressed: (){
                                              showDialog(context: context, builder: (context) => AlertDialog(
                                                title: const Text("New Favorite List"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                        height: 45,
                                                        width: 350,
                                                        decoration: BoxDecoration(
                                                          // color: Colors.white54,
                                                            color: const Color.fromARGB(255, 221, 226, 225)
                                                                .withOpacity(0.9),
                                                            borderRadius:
                                                            const BorderRadius.all(Radius.circular(30))),
                                                        child: TextFormField(
                                                          cursorColor: Colors.grey,
                                                          controller: listNameCtrl,
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
                                                                color: const Color.fromARGB(
                                                                    0, 255, 255, 255),
                                                              ),
                                                              child: const Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 4, horizontal: 8),
                                                                child: Text(
                                                                  ' List Name ',
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
                                                                    color: Colors.transparent, width: 1.5),
                                                                borderRadius: BorderRadius.circular(25),
                                                                gapPadding: 0),
                                                            prefixIconColor: MaterialStateColor.resolveWith(
                                                                    (Set<MaterialState> states) {
                                                                  if (states.contains(
                                                                      MaterialState.focused)) {
                                                                    return Colors.teal;
                                                                  }
                                                                  return Colors.teal.withOpacity(0.4);
                                                                }),
                                                          ),
                                                        )),
                                                    FilledButton(onPressed: (){
                                               //       _addFavoriteList();
                                                    }, child: Text("Save",),),
                                                  ],
                                                ),
                                              ));
                                            }, label: Text("Create Favorite List"),icon: Icon(Icons.add_circle_outline),),
                                            FilledButton(onPressed: (){
                                              try{
                                             //   _addToFavorite("hotels", e.id!, selected!.id!);
                                              }catch (e){
                                                Fluttertoast.showToast(msg: e.toString());
                                              }
                                            }, child: Text("Add to favorite"))

                                          ],
                                        ),
                                      );});
                                    });
                                  },
                                  icon: const Icon(Icons.favorite_border),
                                  alignment: Alignment.bottomRight,
                                ),
                              ],
                            ),
                          ),),
                        ],
                      );
                    }else if(state is HotelEmptyState){
                      return const Center(
                        child: Text("There is no hotels for now"),
                      );
                    }else if(state is HotelLoadingFailedState){
                      Fluttertoast.showToast(msg: state.errorMessage);
                      return const SizedBox();
                    }else{
                      return const SizedBox();
                    }
                  }

                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(52, 0, 0, 0),
                offset: Offset(0.5, 0.5),
                blurRadius: 13,
                spreadRadius: 0.5,
                blurStyle: BlurStyle.normal,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          child: GNav(
            backgroundColor: Colors.white,
            activeColor: Colors.teal,
            tabBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.all(15),
            gap: 4,
            selectedIndex: 2,
            tabs: [
              GButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  Packages()));
                },
                icon: Icons.map_rounded,
                text: 'packages',
              ),
               GButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) {
                     return TransactionPage();
                   },));
                 },
                icon: Icons.trip_origin,
                text: 'transactions',
              ),
              const GButton(
                icon: Icons.home,
                text: 'home',
              ),
              GButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/favorites");
                },
                icon: Icons.favorite,
                text: 'favorit',
              ),
              GButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/all flights");
                },
                icon: Icons.flight,
                text: 'flight',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
