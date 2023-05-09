import 'package:flutter/material.dart';
import 'package:main/UI/auth/login_screen.dart';
import 'package:main/utils/utils.dart';
import 'package:main/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/UI/auth/sign_up_phone.dart';
import '../../../firestore_service.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  bool _obscureText = true;
  final _fromkey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid;
  }

  @override
  void dispose() {
    // emailController.clear();
    // passwordController.clear();
    // usernameController.clear();
    super.dispose();
  }

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
      uid = _auth.currentUser?.uid;

      setState(() {
        loading = false;
      });

      // Create user data object
      Map<String, dynamic> userData = {
        'email': emailController.text.toString(),
        'password': passwordController.text.toString(),
        'username': usernameController.text.toString()
      };

      // Add user data to Firestore
      FirestoreService().addDocument(value.user!.uid, userData);
      // print(value.user!.uid);

      // Show local notification dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Sign Up Successful"),
            content: const Text("You have successfully signed up."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
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

  Center _logo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 43),
          SizedBox(
            height: 100,
            child: Image.asset("Assets/logo.png"),
          ),
          const Text(
            'Create account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 46, 1, 26),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 248, 155, 201),
                      Color.fromARGB(255, 46, 1, 26)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    _logo(),
                    SizedBox(height: 30),
                    Form(
                      key: _fromkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 254, 254),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 110, 8, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 97, 6, 0)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 254, 254),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 97, 6, 0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 97, 6, 0)),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons
                                            .visibility_off, // show/hide password icon based on the boolean variable
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText =
                                          !_obscureText; // toggle password visibility on button press
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 97, 6, 0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 97, 6, 0)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  return 'Use min 8 letters and uppercase&lowercase&numbers&special characters.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: RoundButton(
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
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 46, 1, 26),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16 // set the text color to red
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login_Phone()),
                              );
                            },
                            child: SizedBox(
                              width: 300,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Signup with phone",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
