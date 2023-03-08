// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Stream<QuerySnapshot> streamDocuments() {
//     return _db.collection('users').snapshots();
//   }

//   Future<void> addDocument(Map<String, dynamic> data) {
//     return _db.collection('users').add(data);
//   }

//   Future<void> updateDocument(String id, Map<String, dynamic> data) {
//     return _db.collection('users').doc(id).update(data);
//   }

//   Future<void> deleteDocument(String id) {
//     return _db.collection('users').doc(id).delete();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> streamDocuments() {
    return _db.collection('users').snapshots();
  }

  Future<void> addDocument(Map<String, dynamic> data) {
    return _db.collection('users').add(data);
  }

  Future<void> updateDocument(String id, Map<String, dynamic> data) {
    return _db.collection('users').doc(id).update(data);
  }

  Future<void> deleteDocument(String id) {
    return _db.collection('users').doc(id).delete();
  }
}

