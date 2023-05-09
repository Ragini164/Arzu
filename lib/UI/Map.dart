import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:main/UI/post/current_location.dart';
import '../glassmorphism.dart';
import 'package:main/lib/UI/post/current_location.dart';
import '../donationplacesMap.dart';
import 'consumationmap.dart';

class map_option extends StatefulWidget {
  const map_option({super.key});

  @override
  State<map_option> createState() => _map_optionState();
}

class _map_optionState extends State<map_option> {
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
                      'Congratulations!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your donation has been made available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'You can either wait for the consumer to aaproach you or click below to find the places for donation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ]),
            ),
            options(
                "Check places for Donation",
                const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.0,
                ),
                AppFunctionality()),
              
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
                        MaterialPageRoute(
                            builder: (context) => AppFunctionality()));
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
