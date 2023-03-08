import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:main/UI/auth/Verifycode.dart';
import 'package:main/utils/utils.dart';
import 'package:main/widgets/round_button.dart';

import '../../widgets/round_button.dart';

class Login_Phone extends StatefulWidget {
  const Login_Phone({super.key});

  @override
  State<Login_Phone> createState() => _Login_PhoneState();
}

class _Login_PhoneState extends State<Login_Phone> {
  
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;


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
          
          Padding(
            
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(
                height: 100,
              ),
              TextFormField(
                controller: phoneNumberController,
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '+1 234 3455 234'),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  data: "Login",
                  loading: loading,
                  ontap: () {
                    setState(() {
                      loading = true;
                    });
                    // color: Colors.white;
                    color:
                    Colors.white;
                    textColor:
                    Color.fromARGB(255, 46, 1, 26);

                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text.toString(),
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMessage(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCode(
                                        verificationId: verificationId,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                  })
            ]),
          )
        ]));
  }
}
