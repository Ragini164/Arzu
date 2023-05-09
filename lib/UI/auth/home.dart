
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If we reach here, the data is available and not loading
          final userDocuments = snapshot.data?.docs;
          if (userDocuments != null) {
            final userData = userDocuments.first.data();
              return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Name: ${(userData as Map<String, dynamic>)['name']}',
            style: TextStyle(fontSize: 24.0),
          ),
          Text(
            'Phone Number: ${(userData as Map<String, dynamic>)['phone']}',
            style: TextStyle(fontSize: 24.0),
          ),
          Text(
            'Email Address: ${(userData as Map<String, dynamic>)['email']}',
            style: TextStyle(fontSize: 24.0),
          ),
        ],
      );
          } else {
            // handle the case where snapshot.data is null
            return Center(child: Text('No data available'));
          }
        },
      ),
      
    );
  }
}


