import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Locations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter a location name',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final location = _locations[index];
                  if (_searchController.text.isNotEmpty &&
                      !location.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())) {
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                    title: Text(location.name),
                    subtitle: Text(location.address),
                    onTap: () {
                      Navigator.of(context).pop(location);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Location {
  const Location({required this.name, required this.address});

  final String name;
  final String address;
}

final _locations = <Location>[
  Location(name: 'Location A', address: 'Address A'),
  Location(name: 'Location B', address: 'Address B'),
  Location(name: 'Location C', address: 'Address C'),
  Location(name: 'Location D', address: 'Address D'),
];
