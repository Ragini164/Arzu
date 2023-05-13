import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InterestedUsers extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> interestedUsersCollection =
      FirebaseFirestore.instance.collection('interestedUsers');
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _deleteInterestedUser(String documentId) async {
    await interestedUsersCollection.doc(documentId).delete();
  }

  Future<void> _launchDialPad(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(phoneLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interested Users'),
        backgroundColor: const Color.fromARGB(255, 248, 155, 201),
      ),
      body: currentUser == null
          ? Center(
              child: Text('Please sign in to view interested users.'),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: interestedUsersCollection
                  .where('donorUserId', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No interested users found.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
                    final String interestedUserName =
                        data['interestedUserName'].toString();
                    final String interestedUserPhone =
                        data['interestedUserPhone'].toString();
                    final String documentId = snapshot.data!.docs[index].id;

                    return ListTile(
                      title: Text(interestedUserName),
                      subtitle: GestureDetector(
                        child: Text(
                          interestedUserPhone,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          _launchDialPad(interestedUserPhone);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteInterestedUser(documentId);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
