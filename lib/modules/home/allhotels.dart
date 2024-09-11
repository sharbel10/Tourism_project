
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/hotel/bloc/hotel_bloc.dart';
import '../../models/hotel/hotel.dart';

class allhotels extends StatefulWidget {
  const allhotels({super.key});

  @override
  State<allhotels> createState() => _allhotelsState();
}

class _allhotelsState extends State<allhotels> {
  final searchhotels = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'All hotels',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        ],
      ),
      body: BlocBuilder<HotelBloc,HotelState>( builder: (context,state) {
        if(state is HotelLoadingState){
          return const Center(child: CircularProgressIndicator(),);
        }else if(state is HotelLoadedState){
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 226, 225)
                        .withOpacity(0.9),
                    borderRadius: BorderRadius.circular(35)),
                child: TypeAheadField<Hotel>(
                  controller: searchhotels,
                  emptyBuilder: (con) {
                    return Container(
                        padding: const EdgeInsets.all(12),
                        child: const Text("There is no results"));
                  },
                  builder: (context, c, n) {
                    return TextField(
                      controller: searchhotels,
                      focusNode: n,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Search for hotel",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,color: Colors.teal
                        ),
                        suffixIcon: Icon(
                          Icons.search_outlined,
                        ),
                        border: InputBorder.none,
                      ),
                    );
                  },
                  itemBuilder: (context, d) {
                    return ListTile(
                      title: Text(d.name ?? ""),
                      subtitle: Text(d.region?.name ?? ""),
                      onTap: (){
                        Navigator.of(context).pushNamed('/hotel ditales',arguments: d.id);
                      },
                    );
                  },
                  onSelected: (c) {
                    // controller.onSubCourseTapped(c);
                  },
                  suggestionsCallback: (text){
                    return state.allHotels.where((h) => h.name!.contains(text) || h.region!.name!.contains(text)).toList();
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...state.allHotels.map((e) => InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed('/hotel ditales',arguments: e.id);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 200,
                        width: 250,
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
                                            right: 80, top: 8, left: 15),
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
                                          // SizedBox(width: 20,),
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
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.pin_drop_rounded,
                                              color:
                                              Colors.teal.withOpacity(0.5),
                                              size: 17,
                                            ),
                                            Text(
                                              '${e.region?.name}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            '${e.roomPrice}\$',
                                            style:
                                            const TextStyle(color: Colors.grey),
                                          ),
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
                    ),)
                  ],
                ),
              ),
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
      }),
    );

  }
}
