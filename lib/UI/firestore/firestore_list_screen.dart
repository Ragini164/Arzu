import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/UI/auth/login_screen.dart';
import 'package:main/utils/utils.dart';

import '../../glassmorphism.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;

  Widget _function() {
    return SizedBox(
        child: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(height: 130),
      _donate(),
      _consume(),
      const SizedBox(height: 20),
      // _back(context),
    ])));
  }

  Widget _donate() {
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
          width: 440,
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
                      vertical: 30,
                      horizontal: 40,
                    ),
                    child: const Text(
                      'Donate   ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const DonatorDetails()),
                    // );
                    // handle push to HomeScreen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _consume() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 0,
      ),
      child: Glassmorphism(
        blur: 15,
        opacity: 0.2,
        radius: 20,
        child: Container(
          width: 400,
          height: 150,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Glassmorphism(
                blur: 20,
                opacity: 0.1,
                radius: 20,
                child: TextButton(
                  onPressed: () 
                  {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const ConsumerDetails()),
                    // );                    // handle push to HomeScreen
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ),
                    child: const Text(
                      'Consume   ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // )?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("DashBoard"),
        actions: [
          IconButton(onPressed: () {
            auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder : (context) => const LoginScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10,
          )
        ],
        backgroundColor: const Color.fromARGB(255, 248, 155, 201),
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
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(children: const [
              ]),
            ),
          ),
          _function(),
        ],
      ),
    );
  }
}