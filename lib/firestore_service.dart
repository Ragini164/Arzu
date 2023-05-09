import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> streamDocuments() {
    return _db.collection('users').snapshots();
  }

  Future<void> addDocument(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(data);
  }

  Future<void> updateDocument(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).update(data);
  }
//   Future<void> updateDocument(String uid, Map<String, dynamic> data) async {
//   String newPassword = data['password'];
//   data.remove('password'); // remove the password field from the data object
//   await _db.collection('users').doc(uid).update(data);
//   if (newPassword != null) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await user.updatePassword(newPassword);
//     }
//   }
// }

  Future<void> deleteDocument(String uid) {
    return _db.collection('users').doc(uid).delete();
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    if (uid != null) {
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(uid).get();
      return userDoc;
    } else {
      throw Exception("User ID is null");
    }
  }
}
