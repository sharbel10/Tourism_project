import 'package:comeback/All_Transactions.dart';
import 'package:comeback/Auth/Forget_password.dart';
import 'package:comeback/Auth/Verification_code.dart';
import 'package:comeback/Create_Wallet.dart';
import 'package:comeback/Intro_pages/intropage.dart';
import 'package:comeback/Intro_pages/page1.dart';
import 'package:comeback/Intro_pages/page2.dart';
import 'package:comeback/Intro_pages/page3.dart';
import 'package:comeback/Localization/AppLocalizations.dart';
import 'package:comeback/Localization/Cubit/Locale_Cubit.dart';
import 'package:comeback/Localization/Cubit/Locale_State.dart';
import 'package:comeback/Auth/Login.dart';
import 'package:comeback/Auth/Login_or_Signup.dart';
import 'package:comeback/modules/home/homepage.dart';
import 'package:comeback/passwordbloc/PasswordVisibility_bloc.dart';
import 'package:comeback/tracking.dart';
import 'package:comeback/tracking_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'Packages/Packages.dart';
import 'models/country/bloc/country_bloc.dart';
import 'models/country/country_repository.dart';
import 'models/flight/bloc/flight_bloc.dart';
import 'models/flight/flight_repository.dart';
import 'models/hotel/bloc/hotel_bloc.dart';
import 'models/hotel/hotel_repository.dart';
import 'modules/home/Favoritpage.dart';
import 'modules/home/allcountries.dart';
import 'modules/home/allhotels.dart';
import 'modules/home/bookingflights.dart';
import 'modules/home/contrydetails.dart';
import 'modules/home/hotelditales.dart';
import 'modules/home/search_page.dart';

final String baseurl = "http://192.168.1.107:8000/";
String currentPackageType = '';
// var token = '8|r7BMb3pAj5olGWSUO4KU6BiGUkwGgd4RyiTV6pyXc3fc5ab3';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDiIAVvsTtf0t69SHuSdByx09mITTZkSms',
          appId: '1:757419007686:android:0d9c06e4a6b810b54601c7',
          messagingSenderId: '757419007686',
          projectId: 'flutter-94a83'
      ))
      : await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('login_token');
  final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  runApp( MyApp(token: token,isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget  {
  final String? token;
  final bool? isFirstRun;
  MyApp({super.key, required this.token, required this.isFirstRun});
  // This widget is the root of your application.
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Widget _getInitialPage() {
    if (isFirstRun==true) {
      return intropage();
    } else if (token != null) {
      return homepage(); // Navigate to Packages page if token is present
    } else {
      return Login_or_Signup(); // Navigate to LoginOrSignup page if no token is present
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => CountryRepository(),
          ),
          RepositoryProvider(
            create: (context) => HotelRepository(),
          ),
          RepositoryProvider(create: (context) => FlightRepository())
        ],
        child:   MultiBlocProvider(
            providers: [
              BlocProvider<PasswordVisibilityBloc>(
                create: (BuildContext context) {
                  return PasswordVisibilityBloc();
                },
              ),
              BlocProvider<Locale_cubit>(
                create: (context) {
                  return Locale_cubit()..getSavedLanguage();
                },
              ),
              BlocProvider(
                lazy: false,
                create: (BuildContext context) => CountryBloc(
                  countryRepository: context.read<CountryRepository>(),
                ),
              ),
              BlocProvider(
                lazy: false,
                create: (BuildContext context) => HotelBloc(
                  hotelRepository: context.read<HotelRepository>(),
                ),
              ),
              BlocProvider(
                lazy: false,
                create: (BuildContext context) => FlightBloc(
                  flightRepository: context.read<FlightRepository>(),
                ),
              ),
            ],
            child: BlocBuilder<Locale_cubit, ChangedLocalState>(
                builder: (context, state) {
                  return   ScreenUtilInit(
                      designSize: const Size(411,844),
                      minTextAdapt: true,
                      splitScreenMode: true,
                      // Use builder only if you need to use library outside ScreenUtilInit context
                      builder: (_ , child) {

                        return MaterialApp(
                            navigatorKey: navigatorKey,
                            initialRoute: '/',
                            onGenerateRoute: (settings){
                              switch(settings.name){
                                case '/':
                                  return MaterialPageRoute(builder: (context) => const homepage(),);
                                case '/contry ditales' : {
                                  final arguments = settings.arguments as int;
                                  return MaterialPageRoute(builder: (context) => contryditales(countryId: arguments,),);
                                }
                                case "/hotel ditales": {
                                  final arguments = settings.arguments as int;
                                  return MaterialPageRoute(builder: (context) => hotelditales(hotelId: arguments,),);
                                }
                                case '/all flights' : {
                                  return MaterialPageRoute(builder: (context) => const bookingflights(),);
                                }

                              case '/favorites' : {
                                return MaterialPageRoute(builder: (context) =>  FavoriteListWidget(),);
                              }
                              }
                            },
                            routes: {
                              '/Packages': (context) => Packages(),
                              '/Login': (context) => Login(),
                              '/LoginorSignup': (context) => Login_or_Signup(),
                              '/all countries': (context) => const allcountreis(),
                              '/all hotels': (context) => allhotels(),
                              '/search page': (context) => serachpage(),
                              '/homepage': (context) => homepage(),
                              '/all flights': (context) => const bookingflights(),
                              '/all hotels': (context) => allhotels(),

                              // '/hotel ditales': (context) => hotelditales(hotelId: ,),
                              //'/contry ditales': (context) => contryditales(countryId: 1),
                              // Define other routes here
                            },
                            scaffoldMessengerKey: scaffoldMessengerKey,
                            title: 'Flutter Demo',
                            theme: ThemeData(
                              colorScheme: ColorScheme.fromSeed(
                                  seedColor: Colors.deepPurple
                              ),
                              useMaterial3: true,
                            ),
                            debugShowCheckedModeBanner: false,
                            locale: Locale(state.locale),
                            supportedLocales: [
                              Locale('en'),
                              Locale('ar'),
                            ],
                            localizationsDelegates: [
                              AppLocalizations.delegate,
                              GlobalMaterialLocalizations.delegate,
                              GlobalCupertinoLocalizations.delegate,
                              GlobalWidgetsLocalizations.delegate
                            ],
                            localeResolutionCallback: (devicelocale, supportedlocales) {
                              for (var locale in supportedlocales) {
                                if (devicelocale != null &&
                                    devicelocale.languageCode == locale.languageCode) {
                                  return devicelocale;
                                }
                              }
                              return supportedlocales.first;
                            },

                            home:
                            // TransactionPage()
                            _getInitialPage()


                        );
                      }
                  );
                }
            )
        )
    );
  }
}
// Positioned(
//   bottom: 0,
//   left: 20,
//   right: 20,
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       width: MediaQuery.of(context).size.width * 0.9,
//       height: MediaQuery.of(context).size.height * 0.07,
//       decoration: BoxDecoration(
//         color: Color(0xff05a4a5),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Center(
//         child: Text(
//           // AppLocalizations.of(context)!.translate("login"),
//             "Book Now",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20)),
//       ),
//     ),
//   ),
// ),
