import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodDataScreen extends StatefulWidget {
  @override
  _FoodDataScreenState createState() => _FoodDataScreenState();
}

class _FoodDataScreenState extends State<FoodDataScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 155, 201),
        title: Text('Food Data Record'),
      ),
      body: Container(
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
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('foodData')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final documents = snapshot.data!.docs;

              if (documents.isEmpty) {
                return Center(child: Text('No data available.'));
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];

                  void updateAvailability(bool newValue) {
                    doc.reference
                        .update({'isAvailable': newValue}).then((value) {
                      // Call setState to update the UI
                      setState(() {});
                    });
                  }

                  return Card(
                    color: Color.fromARGB(0, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        doc['foodDetails'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        doc['fullName'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                doc['isAvailable']
                                    ? 'Available'
                                    : 'Not Available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: doc['isAvailable']
                                      ? Color.fromARGB(255, 7, 10, 8)
                                      : Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Switch(
                                value: doc['isAvailable'],
                                onChanged: (newValue) {
                                  setState(() {
                                    updateAvailability(newValue);
                                  });
                                },
                                activeColor: Colors.white,
                                inactiveTrackColor: Colors.black,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
