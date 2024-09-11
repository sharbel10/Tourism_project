import 'package:comeback/Auth/Login_or_Signup.dart';
import 'package:flutter/material.dart';

class page3 extends StatefulWidget {
  const page3({super.key});

  @override
  State<page3> createState() => _page3State();
}

class _page3State extends State<page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: 
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
                padding: const EdgeInsets.only(top: 70, right: 130, left: 30),
                child: Column(
                  
                  children: [
                    Text(
                      'Plan your dream\ntravel experience ',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                   
                  ],
                )),
                             SizedBox(height: 500,),
                    InkWell(
                      onTap: (){
                        print("tapped");
                       Navigator.pushReplacement(context,
                       MaterialPageRoute(builder: (context) {
                         return Login_or_Signup();
                       },));
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                                   BoxShadow( color: Color.fromARGB(164, 0, 0, 0),
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 13,
                                    spreadRadius: 1,
                                    blurStyle: BlurStyle.normal,)
                          ],
                            color: Color.fromARGB(223, 0, 150, 135),
                            borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Text(
                                'let\'s start',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                                
                                ),
                            ),
                      ),
                    ),
                    SizedBox(height: 70,)
                  ],
                ),
              )),);
  }
}
