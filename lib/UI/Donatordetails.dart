import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/UI/Map.dart';
// import 'package:main/UI/post/AvailableConsumers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DonatorDetails extends StatefulWidget {
  const DonatorDetails({super.key});

  @override
  State<DonatorDetails> createState() => _DonatorDetailsState();
}

class _DonatorDetailsState extends State<DonatorDetails> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final organizationController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final numberOfItemsController = TextEditingController();
  final foodDetailsController = TextEditingController();
  final expiryDateController = TextEditingController();

  bool isAvailable = true;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    fullNameController.dispose();
    organizationController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    numberOfItemsController.dispose();
    foodDetailsController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'userId': FirebaseAuth.instance.currentUser!.uid, // add user ID here
        'fullName': fullNameController.text,
        'organization': organizationController.text,
        'phoneNumber': phoneNumberController.text,
        'address': addressController.text,
        'numberOfItems': int.parse(numberOfItemsController.text),
        'foodDetails': foodDetailsController.text,
        'expiryDate': DateTime.parse(expiryDateController.text),
        'isAvailable': isAvailable,
      };
      print("in donator detail " + "userId");
      await FirebaseFirestore.instance.collection('foodData').add(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donation added to Firestore!'),
        ),
      );

      // Navigate to the Map screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const map_option()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 248, 155, 201),
          elevation: 4.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text('Donation Form'),
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5591F),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 248, 155, 201),
                  Color.fromARGB(255, 46, 1, 26),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Organization',
                      ),
                      controller: organizationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your oraganization';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '03340236768',
                      ),
                      controller: phoneNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Number of Items',
                      ),
                      controller: numberOfItemsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of items';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Food Details',
                      ),
                      controller: foodDetailsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter food details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(), // Set minimum date as today
                          onConfirm: (date) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(date);
                            expiryDateController.text = formattedDate;
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.en,
                        );
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                          ),
                          controller: expiryDateController,
                        ),
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     DatePicker.showDatePicker(
                    //       context,
                    //       showTitleActions: true,
                    //       onConfirm: (date) {
                    //         expiryDateController.text = date.toString();
                    //       },
                    //       currentTime: DateTime.now(),
                    //       locale: LocaleType.en,
                    //     );
                    //   },
                    //   child: AbsorbPointer(
                    //     child: TextFormField(
                    //       decoration: InputDecoration(
                    //         labelText: 'Expiry Date',
                    //       ),
                    //       controller: expiryDateController,
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _submit(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
