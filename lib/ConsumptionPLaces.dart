import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:places/places.dart';

class ConsumptionMap extends StatefulWidget {
  @override
  State<ConsumptionMap> createState() => ConsumptionMapState();
}

class ConsumptionMapState extends State<ConsumptionMap> {
  late GoogleMapController mapController;
  String searchQuery = '';
  List<Location> searchResults = [];
  Set<Marker> markers = {};
  List<Polyline> _polylines = [];
  final LatLng _center = const LatLng(24.8270, 67.0251);
  Position? currentLocation;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addMarkers();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle location permission denied
        return;
      }
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = position;
      });
      _animateToCurrentLocation();
      _listenToLocationChanges();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _listenToLocationChanges() {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  void _animateToCurrentLocation() {
    if (currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation!.latitude,
              currentLocation!.longitude,
            ),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarkers() {
    markers.add(
      const Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(24.87257824692783, 67.09084451079175),
        infoWindow: InfoWindow(title: 'Lal Qila'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(24.75707956177029, 67.09590285316284),
        infoWindow: InfoWindow(title: 'Kababjees Restaurant Do Darya'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(24.82134843189884, 67.02255538621091),
        infoWindow: InfoWindow(title: 'Bar B.Q Tonight Clifton'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker4'),
        position: LatLng(24.809506800843277, 67.02942184107455),
        infoWindow: InfoWindow(title: 'Bar B.Q Tonight'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker5'),
        position: LatLng(24.949306854143842, 67.20224001329275),
        infoWindow: InfoWindow(title: 'Bar B.Q Tonight'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker6'),
        position: LatLng(24.824195440524107, 67.03566008200099),
        infoWindow: InfoWindow(title: 'Kolachi Restaurant'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker7'),
        position: LatLng(24.908127819369867, 67.13910146481093),
        infoWindow: InfoWindow(title: 'Farhan Biryani'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker8'),
        position: LatLng(24.755760876077616, 67.0937479835293),
        infoWindow: InfoWindow(title: 'Charcoal BBQ n Grill Restaurant'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker9'),
        position: LatLng(24.885893606022123, 67.07251051798139),
        infoWindow: InfoWindow(title: 'Zameer Ansari'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(24.841037470556895, 67.03817824366321),
        infoWindow: InfoWindow(title: 'Zameer Ansari'),
      ),
    );
    markers.add(
      const Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(24.87528178200341, 67.09527710898844),
        infoWindow: InfoWindow(title: 'Rosati Bistro'),
      ),
    );
  }

  void _onSearch(String query) async {
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15.0,
        ),
      ));
      setState(() {
        searchQuery = query;
        searchResults = locations;
        markers.removeWhere((marker) => true);
        markers.add(
          Marker(
            markerId: MarkerId(
              location.latitude.toString() + location.longitude.toString(),
            ),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: query),
          ),
        );
      });
    } else {
      setState(() {
        searchQuery = query;
        searchResults = [];
      });
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      markers.clear();
      _polylines.clear();
      if (markers.length == 1) {
        final source = markers.first.position;
        _getDirections(source, latLng);
      }
      markers.add(
        Marker(
          markerId: MarkerId('${latLng.latitude}-${latLng.longitude}'),
          position: latLng,
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            print('Marker was dragged from $latLng to $newPosition');
          },
        ),
      );
    });
  }

  Future<void> _getDirections(LatLng source, LatLng destination) async {
    // TODO: Implement this method to get directions using the Google Maps Directions API
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kavish-Arzu",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Kavish-Arzu"),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation?.latitude ?? _center.latitude,
                  currentLocation?.longitude ?? _center.longitude,
                ),
                zoom: 11.0,
              ),
              markers: markers,
              myLocationEnabled: true,
            ),
            Positioned(
              top: 50.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        onChanged: _onSearch,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _onSearch(searchQuery),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
