import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../../models/country/bloc/country_details_bloc.dart';
import '../../models/country/country_repository.dart';

class contryditales extends StatelessWidget {
  const contryditales({super.key, required this.countryId});

  final int countryId;

  @override
  Widget build(BuildContext context) {
    List<String> titels = [
      'peace',
      'calme',
      'enjoy',
    ];

    List<Widget> image = [
      Hero(
          tag: 'peace',
          child: Container(
            height: 30,
            width: 30,
            // color: Colors.white30
            // ,
            decoration: const BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(200))),
          )),
      Hero(
          tag: 'calme',
          child: Container(
            height: 30,
            width: 30,
            // color: Colors.white30,
            decoration: const BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(200))),
          )),
      Hero(
          tag: 'enjoy',
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(200))),
            height: 30,
            width: 30,
          )),
    ];
    return RepositoryProvider(
      create: (context) => CountryRepository(),
      child: BlocProvider<CountryDetailsBloc>(
        create: (context) => CountryDetailsBloc(
            countryRepository: context.read<CountryRepository>()),
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
                          color: Colors.black45.withOpacity(0.2)),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black38, size: 30)),
                ),
              ),
            ),
            body: BlocBuilder<CountryDetailsBloc, CountryDetailsState>(
                builder: (context, state) {
              if (state is CountryDetailsInitial) {
                context
                    .read<CountryDetailsBloc>()
                    .add(GetCountryDetailsEvent(id: countryId));
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CountryDetailsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CountryDetailsLoadedState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(1),
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 13,
                                  spreadRadius: 1,
                                  blurStyle: BlurStyle.normal,
                                )
                              ],
                              image: const DecorationImage(
                                  image: AssetImage(
                                    'images/s6.jpg',
                                  ),
                                  fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: VerticalCardPager(
                                align: ALIGN.RIGHT,
                                titles: titels,
                                images: image,
                                initialPage: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        // height: double.maxFinite,
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'images/pin (1).png'))),
                                      ),
                                      Text(
                                        '${state.details.name}',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            shadows: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset:
                                                      Offset.fromDirection(10),
                                                  blurRadius: 3,
                                                  blurStyle: BlurStyle.normal)
                                            ]),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        size: 30,
                                        color: Colors.teal,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 30,
                                top: 10,
                              ),
                              child: Text(
                                'Description \n ${state.details.description}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 30),
                              child: Text(
                                'Popular cities',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset.fromDirection(0.3),
                                          blurRadius: 0.5,
                                          blurStyle: BlurStyle.normal)
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                'Cities you may visit',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Container(
                                height: 70,
                                width: double.maxFinite,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: state.details.cities != null
                                      ? [
                                          ...state.details.cities!.map(
                                            (c) => Container(
                                              height: 30,
                                              width: 220,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  boxShadow: [
                                                    const BoxShadow(
                                                        color: Colors.black26,
                                                        offset: Offset(-0.7, 1),
                                                        spreadRadius: 1,
                                                        blurRadius: 0.5,
                                                        blurStyle:
                                                            BlurStyle.normal)
                                                  ]),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: double.maxFinite,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.teal,
                                                          image:
                                                              const DecorationImage(
                                                            image: AssetImage(
                                                              'images/s5.jpg',
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          boxShadow: [
                                                            const BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                offset: Offset(
                                                                    -0.5, 1),
                                                                spreadRadius: 1,
                                                                blurRadius: 0.5,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .normal)
                                                          ]),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      '${c.name}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                      : [],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is CountryDetailsLoadingFailedState) {
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
