import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:main/UI/auth/Verifycode.dart';
import 'package:main/UI/auth/verify.dart';
import 'package:main/utils/utils.dart';
import 'package:main/widgets/round_button.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/round_button.dart';

class Login_Phone extends StatefulWidget {
  const Login_Phone({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white, // set the background color here
            gradient: LinearGradient(
              colors: [
                (Color.fromARGB(255, 248, 155, 201)),
                Color.fromARGB(255, 46, 1, 26),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 46, 1, 26),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Text(
                  'Please enter your mobile number to receive an OTP verification code',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 46, 1, 26),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center, // center align the text
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  children: [
                    TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          hintText: '+92 234 3455 234',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 161, 161, 161)),
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 161, 161, 161),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        )),
                    const SizedBox(height: 20),
                    RoundButton(
                        data: "Sign Up",
                        loading: loading,
                        ontap: () {
                          setState(() {
                            loading = true;
                          });
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
                                  ),
                                ),
                              );
                              setState(() {
                                loading = false;
                              });
                            },
                            codeAutoRetrievalTimeout: (e) {
                              Utils().toastMessage(e.toString());
                              setState(() {
                                loading = false;
                              });
                            },
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
