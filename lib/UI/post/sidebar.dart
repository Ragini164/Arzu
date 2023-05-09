import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/UI/post/deleteAccount.dart';
import 'package:main/UI/post/interested.dart';
import 'package:main/UI/post/profile.dart';

import '../auth/login_screen.dart';
import 'UserfoodData.dart';

class MySidebar extends StatelessWidget {
  final String userId;

  const MySidebar({super.key, required this.userId});

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Color(0xffF5591F),
                gradient: LinearGradient(colors: [
                  (Color.fromARGB(255, 248, 155, 201)),
                  Color.fromARGB(255, 46, 1, 26),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Text(
              'Arzu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Donations'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodDataScreen(
                          // userId: userId,
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.sms_rounded),
            title: Text('Interested Consumers'),
            onTap: () {
              // TODO: Implement Settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterestedUsers()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // TODO: Implement Settings page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DeleteAccount()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
