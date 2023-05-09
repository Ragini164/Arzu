import 'package:flutter/material.dart';
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

  // Define otpControllers map
  Map<int, TextEditingController> otpControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize otpControllers map with 6 TextEditingControllers
    for (int i = 1; i <= 6; i++) {
      otpControllers[i] = TextEditingController();
    }
  }
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
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(
                    height: 180,
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 46, 1, 26),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 80,
                    child: Text(
                      'Enter the OTP code sent to your mobile number',
                      style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 46, 1, 26), fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 260,),
                    Flexible(
                      flex: 1,
                      child: _boxes(),
                    ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: RoundButton(
                      data: "Verify",
                      loading: loading,
                      ontap: () async {
                        setState(() {
                          loading = true;
                        });

                        final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: _getOTP());

                        try {
                          await auth.signInWithCredential(credential);
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
                      })),
                ],
              ),
            )
        ]));
  }

Widget _boxes() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(
      6,
      (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: otpControllers[index + 1],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              counter: const Offstage(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              fillColor: Colors.transparent,
              filled: true,
            ),
          ),
        );
      },
    ),
  );
}

  String _getOTP() {
    String otp = "";
    for (int i = 1; i <= 6; i++) {
      otp += otpControllers[i]!.text;
    }
    return otp;
  }

  Future<void> _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _getOTP(),
    );

    try {
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PostScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(e.toString());
    }
  }
}
