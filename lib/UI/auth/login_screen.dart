import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/UI/auth/sign_up.dart';
import 'package:main/UI/post/post_screen.dart';
import 'package:main/crudoperations.dart';
import 'package:main/widgets/round_button.dart';


import '../../utils/utils.dart';
import 'login_with_phone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _fromkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));

      setState(() {
        loading = false;
      });
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
  
  // Center _logo() {
  //   return Center(
  //     child: SizedBox(
  //       height: 100,
  //       child: Image.asset("Assets/logo.png"),
  //     ),
  //   );
  // }
  Center _logo() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Image.asset("Assets/logo.png"),
        ),
        const Text(
          'Welcome to Arzu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        // const SizedBox(
        //   height: 16,
        // ),
        const Text(
          'Please Login',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 15, 15, 15),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   backgroundColor: const Color.fromARGB(255, 248, 155, 201),
            //   elevation: 4.0,
            //   iconTheme: const IconThemeData(
            //     color: Colors.black, //change your color here
            //   ),
            // ),
            body: Stack(children: [
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
              // SizedBox(
              //   height: 180,
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     child: Column(
              //       children: [
              //         // const SizedBox(
              //         //   height: 150,
              //         // ),
              //         _logo(),
              //       ],
              //     ),
              //   ),
              // ),
              // _logo(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _logo(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
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
                            errorStyle: TextStyle(
                                color: Color.fromARGB(255, 46, 1, 26)),
                          ),
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
                      data: 'Login',
                      loading: loading,
                      ontap: () {
                        if (_fromkey.currentState!.validate()) {
                          login();
                        }
                      },
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 // set the text color to red
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Phone()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(),
                          //  color: Colors.black),
                        ),
                        child: const Center( 
                          child: Text("Login with phone"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ])));
  }
}
