import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/country/bloc/country_bloc.dart';

class allcountreis extends StatefulWidget {
  const allcountreis({super.key});

  @override
  State<allcountreis> createState() => _allcountreisState();
}

class _allcountreisState extends State<allcountreis> {
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
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'All Countreis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        ],
      ),
      body: BlocBuilder<CountryBloc, CountryState>(builder: (context, state) {
        if (state is CountryLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CountryLoadedState) {
          return MasonryGridView.builder(
              itemCount: state.countries.length,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/contry ditales',arguments: state.countries[index].id);
                      },
                      child: Container(
                        height: 140,
                        width: 160,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite_border))
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white24.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${state.countries[index].name}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      '${state.countries[index].description}',
                                      style: TextStyle(
                                          fontSize: 7.sp,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black45),
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
                      ))));
        } else if (state is CountryEmptyState) {
          return const Center(
            child: Text("There is no recommended countries"),
          );
        } else if (state is CountryLoadingFailedState) {
          Fluttertoast.showToast(msg: state.errorMessage);
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      }),
    );

  }
}
