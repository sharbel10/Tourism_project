import 'package:flutter/material.dart';

class page1 extends StatefulWidget {
  const page1({super.key});

  @override
  State<page1> createState() => _page1State();
}

class _page1State extends State<page1> {
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
                          color: Color.fromARGB(189, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
    );
  }
}