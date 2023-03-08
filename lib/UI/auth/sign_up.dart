import 'package:flutter/material.dart';
import 'package:main/UI/auth/login_screen.dart';
import 'package:main/utils/utils.dart';
import 'package:main/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firestore_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _fromkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // void SignUp()
  // {
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth
  //       .createUserWithEmailAndPassword(
  //           email: emailController.text.toString(),
  //           password: passwordController.text.toString())
  //       .then((value) {
  //         setState(() {
  //           loading = false;
  //         });
  //       })
  //       .onError((error, stackTrace) {
  //     if (error is FirebaseAuthException) {
  //       String errorMessage =
  //           error.message ?? "An error occurred";
  //       Utils().toastMessage(errorMessage);
  //     } else {
  //       Utils().toastMessage(error.toString());
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   });

  // }
  void SignUp() {
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString(),
            )
            
        .then((value) {
      setState(() {
        loading = false;
      });

      // Create user data object
      Map<String, dynamic> userData = {
        'email': emailController.text.toString(),
        'password': passwordController.text.toString()
      };

      // Add user data to Firestore
      FirestoreService().addDocument(userData);

      // Navigate to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        String errorMessage = error.message ?? "An error occurred";
        Utils().toastMessage(errorMessage);
      } else {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 248, 155, 201),
                    Color.fromARGB(255, 46, 1, 26)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _fromkey,
                    child: Column(children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 46, 1, 26)),
                          ),
                          errorStyle:
                              TextStyle(color: Color.fromARGB(255, 46, 1, 26)),
                        ),
                        // ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 46, 1, 26)),
                            ),
                            errorStyle: TextStyle(
                                color: Color.fromARGB(255, 46, 1, 26)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 8) {
                              return 'Password should be at least 8 characters';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                  RoundButton(
                    data: 'Sign Up',
                    loading: loading,
                    ontap: () {
                      if (_fromkey.currentState!.validate()) {
                        SignUp();
                      }
                    },
                    color: Colors.white,
                    textColor: Color.fromARGB(255, 46, 1, 26),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 // set the text color to red
                              ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
