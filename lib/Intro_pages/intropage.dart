import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login_or_Signup.dart';

class intropage extends StatelessWidget {
  intropage({super.key});

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          Container(
            height: double.maxFinite,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'images/s6.jpg',
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 30),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 150, left: 10),
                    child: Text(
                      'Welcome to\nExploreo !',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      ) ,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: double.maxFinite,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'images/s3.jpg',
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Text(
                    'Explore the world with us',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.teal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enjoy the trip,vacation & good',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,fontFamily: 'Montserrat',color: Colors.white),
                  ),
                  Text(
                    'moment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,fontFamily: 'Montserrat',color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Container(
              height: double.maxFinite,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'images/s5.jpg',
                      ),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 70, right: 130, left: 30),
                        child: Column(
                          children: [
                            Text(
                              'Plan your dream\ntravel experiance ',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 500,
                    ),
                    InkWell(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstRun', false);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                            builder: (context) => Login_or_Signup(),
                            ),);
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(164, 0, 0, 0),
                                offset: Offset(0.5, 0.5),
                                blurRadius: 13,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.normal,
                              )
                            ],
                            color: Color.fromARGB(223, 0, 150, 135),
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: Text(
                            'let\'s start',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
