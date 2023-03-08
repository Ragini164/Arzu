import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/UI/post/post_screen.dart';
import 'package:main/crudoperations.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final VerificationCodeController = TextEditingController();
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
                controller: VerificationCodeController,
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '6 digit code'),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  data: "Verify",
                  loading: loading,
                  ontap: () async {
                    setState(() {
                      loading = true;
                    });

                    final crendential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: VerificationCodeController.text.toString());

                    try {
                      await auth.signInWithCredential(crendential);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostScreen()));
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    }
                  })
            ]),
          )
        ]));
  }
}
