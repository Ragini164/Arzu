import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DonationMap extends StatefulWidget {
  const DonationMap({super.key});

  @override
  State<DonationMap> createState() => _DonationMapState();
}

class _DonationMapState extends State<DonationMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 248, 155, 201),
          elevation: 4.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Stack(children: [
      Container(
        
        decoration: const BoxDecoration(
            color: Color(0xffF5591F),
            gradient: LinearGradient(colors: [
              (Color.fromARGB(255, 248, 155, 201)),
              Color.fromARGB(255, 46, 1, 26),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
    ]));
  }
}
