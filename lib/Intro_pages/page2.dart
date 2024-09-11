import 'package:flutter/material.dart';

class page2 extends StatefulWidget {
  const page2({super.key});

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
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
                      'images/s3.jpg',
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Text(
                    'Explore the world with us',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enjoy the trip,vacation & good',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'moment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
    );
  }
}