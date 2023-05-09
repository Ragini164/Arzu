
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/UI/auth/login_screen.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key ?? const ValueKey('default'));

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _deleteUser() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print('User not signed in.');
        return;
      }
      await user.delete(); // Deletes user from Firebase Authentication
      await deleteDocument(user.uid); // Deletes user data from Firestore
      print('User deleted successfully.');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> deleteDocument(String uid) {
    return _db.collection('users').doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _deleteUser();
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // background color
        onPrimary: Colors.black, // foreground color
      ),
      child: const Text('Delete Account'),
    );
  }
}
