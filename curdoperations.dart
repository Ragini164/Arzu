import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_service.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<QuerySnapshot> _documents;

  @override
  void initState() {
    super.initState();
    _documents = _firestoreService.streamDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _documents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['age'].toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final Map<String, dynamic> data = {
                'name': _nameController.text,
                'age': int.parse(_ageController.text),
              };
              await _firestoreService.addDocument(data);
              _nameController.clear();
              _ageController.clear();
            },
            tooltip: 'Add',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await _firestoreService.updateDocument('data', {
                'name': _nameController.text,
                'age': int.parse(_ageController.text),
              });
              _nameController.clear();
              _ageController.clear();
            },
            tooltip: 'Update',
            child: Icon(Icons.update),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await _firestoreService.deleteDocument('data');
            },
            tooltip: 'Delete',
            child: Icon(Icons.delete),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
            ),
          ),
        ],
      ),
    );
  }
}
