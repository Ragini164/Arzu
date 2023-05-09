import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return LoginScreen();
    }
    final String uid = user.uid;
    print('User Id in profile.dart $uid');

    return FutureBuilder<DocumentSnapshot>(
      future: FirestoreService().getUserData(uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error retrieving user data: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Empty container instead of CustomLoadingWidget
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'];
        final email = userData['email'];
        _usernameController.text = username;
        _emailController.text = email;
        // return Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Color.fromARGB(255, 248, 155, 201),
        //         Color.fromARGB(255, 46, 1, 26),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 248, 155, 201),
              title: Text('Profile'),
            actions: [
              IconButton(
                icon: _isEditing ? Icon(Icons.save) : Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      if (_formKey.currentState!.validate()) {
                        // Get the updated username and email from the form
                        final String newUsername =
                            _usernameController.text.trim();
                        final String newEmail = _emailController.text.trim();

                        // Update the user's email in Firebase Authentication if it has been changed
                        if (newEmail != email) {
                          user.updateEmail(newEmail).then((_) {
                            // Show a success message if the email was updated successfully
                            setState(() {
                              _successMessage = 'Email updated successfully!';
                            });
                            // Remove the success message after 3 seconds
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                _successMessage = null;
                              });
                            });
                          }).catchError((error) {
                            // Show an error message if there was an error updating the email
                            setState(() {
                              _errorMessage = 'Error updating email: $error';
                            });
                            // Remove the error message after 3 seconds
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                _errorMessage = null;
                              });
                            });
                          });
                        }

                        // Update the user document in Firestore
                        FirestoreService().updateDocument(uid, {
                          'username': newUsername,
                          'email': newEmail,
                        });
                        _isEditing = false;
                      }
                    } else {
                      _isEditing = true;
                    }
                  });
                },
              ),
            ],
          ),
          body: Container(
            height: 700,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 248, 155, 201),
                    Color.fromARGB(255, 46, 1, 26),
                  ],
                ),
              ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_successMessage != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _successMessage!,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    if (_errorMessage != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        enabled: _isEditing,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabled: _isEditing,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}