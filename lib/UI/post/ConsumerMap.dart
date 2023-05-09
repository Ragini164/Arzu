import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/ConsumptionPLaces.dart';
// import 'package:main/UI/post/current_location.dart';
import 'package:main/lib/UI/post/current_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../glassmorphism.dart';
import 'BykeaScreen.dart';

class ConsumerMap extends StatefulWidget {
  const ConsumerMap({super.key});

  @override
  State<ConsumerMap> createState() => _ConsumerMapState();
}

class _ConsumerMapState extends State<ConsumerMap> {
  Widget _function() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Hello',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'You can either wait for the Donator to approach you or click below to find the places for Consumption.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'You can also utilize the Bykea button below to conveniently get your order picked up.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ]),
            ),
            options(
                "Check places for Consumption",
                const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.0,
                ),
                ConsumptionMap()),
            Container(
              width: 200,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white.withOpacity(0.3),
              ),
              child: TextButton(
                onPressed: () {
                  const phoneNumber = '+923071234567';
                  final telUrl = 'tel:$phoneNumber';
                  launch(telUrl);
                },
                child: const Center(
                  child: Text(
                    'Bykea',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget options(String buttonText, TextStyle textStyle, Widget route) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 20,
      ),
      child: Glassmorphism(
        blur: 15,
        opacity: 0.2,
        radius: 20,
        child: Container(
          width: 550,
          height: 150,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Glassmorphism(
                blur: 20,
                opacity: 0.1,
                radius: 20.0,
                child: TextButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Text(
                      buttonText,
                      style: textStyle,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => route),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 155, 201),
        elevation: 4.0,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xffF5591F),
                gradient: LinearGradient(colors: [
                  (Color.fromARGB(255, 248, 155, 201)),
                  Color.fromARGB(255, 46, 1, 26),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          _function(),
        ],
      ),
    );
  }
}
