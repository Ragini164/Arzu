import 'dart:async';
import 'package:flutter/material.dart';
import 'package:main/UI/auth/login_screen.dart';
import 'package:main/UI/firestore/firestore_list_screen.dart';
import 'package:main/UI/post/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../UI/post/post_screen.dart';

class SplashServices {
  // static Future<void> init() async {
  //   await Firebase.initializeApp();
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // }

  void isLogin(BuildContext context) {
    // if (FirebaseAuth.instance.currentUser != null) {
    //   Get.offAllNamed(Routes.HOME);
    // } else {
    //   Get.offAllNamed(Routes.LOGIN);
    // }
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FireStoreScreen()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
