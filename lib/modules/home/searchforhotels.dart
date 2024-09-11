
import 'package:flutter/material.dart';

class searchforHotels extends StatefulWidget {
  const searchforHotels({super.key});

  @override
  State<searchforHotels> createState() => _searchforHotelsState();
}

class _searchforHotelsState extends State<searchforHotels> {
  final searchhotel = TextEditingController();
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
                child: Icon(Icons.arrow_back_ios_new,
                    color: Colors.black38, size: 30)),
          ),
        ),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
                Container(
          height: 45,
          width: 350,
          decoration: BoxDecoration(
              // color: Colors.white54,
              color: Color.fromARGB(255, 221, 226, 225).withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: TextFormField(
            cursorColor: Colors.grey,
            controller: searchhotel,
            decoration: InputDecoration(
              // filled: true,
              fillColor: Colors.black54,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              errorStyle: TextStyle(
                color: Colors.pink,
                shadows: [
                  Shadow(color: Colors.grey.withOpacity(0.6), blurRadius: 5),
                ],
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              // labelText: 'From',
              prefixIcon: Icon(Icons.search_rounded),
              label: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromARGB(0, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    ' search for a specific hotel ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.withOpacity(0.5),
                      shadows: const [
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
                  color: Colors.tealAccent, fontWeight: FontWeight.w500),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 187, 200, 197), width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                  gapPadding: 0),
              disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                  gapPadding: 0),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                  gapPadding: 0),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                  gapPadding: 0),
              prefixIconColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return Colors.teal;
                }
                return Colors.teal.withOpacity(0.4);
              }),
            ),
          ),
                )
              ]),
        ));
  }
}
