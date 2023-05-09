import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/UI/post/ConsumerMap.dart';
Future<void> _showInterestedDialog(BuildContext context, String donorUserId) async {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter your contact details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: nameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                controller: phoneController,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('interestedUsers').add({
                'donorUserId': donorUserId,
                'interestedUserName': nameController.text,
                'interestedUserPhone': phoneController.text,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Thank you for your interest! Your information has been received by the donator, please wait for them to reach out to you.'),
                ),
              );
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsumerMap(), // Replace 'AnotherScreen' with the screen you want to navigate to
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
// Future<void> _showInterestedDialog(
//     BuildContext context, String donorUserId) async {
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();

//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Enter your contact details'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                 ),
//                 controller: nameController,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Phone',
//                 ),
//                 controller: phoneController,
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.black),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: const Text(
//               'Submit',
//               style: TextStyle(color: Colors.black),
//             ),
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection('interestedUsers')
//                   .add({
//                 'donorUserId': donorUserId,
//                 'interestedUserName': nameController.text,
//                 'interestedUserPhone': phoneController.text,
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text(
//                       'Thank you for your interest! Your information has been recieved by donator, please wait for them to reach out to you.'),
//                 ),
//               );
//               Navigator.of(context).pop();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const ConsumerMap(), // Replace 'AnotherScreen' with the screen you want to navigate to
//                 ),
//               );
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

class FoodData extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> foodCollection =
      FirebaseFirestore.instance.collection('foodData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 155, 201),
        elevation: 4.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('Donations Available'),
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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              foodCollection.where('isAvailable', isEqualTo: true).snapshots(),
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
                child: Text('No data available.'),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs
                    .where((doc) => doc['isAvailable'])
                    .length, // filter based on isAvailable
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> data =
                      snapshot.data!.docs[index].data();
                  final String name = data['fullName'].toString();
                  final String phone = data['phoneNumber'];
                  final String address = data['address'].toString();
                  final String foodDetails = data['foodDetails'].toString();
                  final bool isAvailable = data['isAvailable'];
                  final String u = data['userId'].toString();

                  if (!isAvailable) {
                    // skip if isAvailable is false
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        foodDetails,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: $name',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Phone: $phone',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Address: $address',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Food Details: $foodDetails',
                                style: const TextStyle(fontSize: 16),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _showInterestedDialog(
                                      context, data['userId']);
                                },
                                child: const Text(
                                  'Interested',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 20,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
