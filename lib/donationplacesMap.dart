import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:places/places.dart';

class AppFunctionality extends StatefulWidget {
  @override
  State<AppFunctionality> createState() => AppFunctionalityState();
}

class AppFunctionalityState extends State<AppFunctionality> {
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
      Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(24.944012082640388, 67.04802918263827),
        infoWindow: InfoWindow(title: 'Sarim Burney Trust Shelter Home'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(24.871090441686263, 67.08397769165173),
        infoWindow: InfoWindow(title: 'Gills Shelter old age home'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(24.924716567555173, 67.12426570538497),
        infoWindow: InfoWindow(
            title: 'Gosha Khatoon-e-Jannat Senior Citizens Home for Ladies'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker4'),
        position: LatLng(24.963317481393553, 67.03843501872417),
        infoWindow: InfoWindow(title: 'Karachi Shelter'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker5'),
        position: LatLng(24.958337398096482, 67.06040767450935),
        infoWindow: InfoWindow(title: 'Anmol Zindagi Old Age Home'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker6'),
        position: LatLng(24.904788784461296, 67.1029796950931),
        infoWindow: InfoWindow(title: 'AL MADINA PLAZA'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker7'),
        position: LatLng(24.97452193202566, 67.12975886933127),
        infoWindow: InfoWindow(title: 'ASHFAQ MANZIL'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker8'),
        position: LatLng(24.97514437158803, 67.15173152511643),
        infoWindow: InfoWindow(title: 'PBM Shelterhome Karachi-1'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker9'),
        position: LatLng(24.98572536221863, 67.17095759892844),
        infoWindow: InfoWindow(title: 'Baitul-Shafique Manzil'),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('marker10'),
        position: LatLng(24.998794740607998, 67.08650020325423),
        infoWindow: InfoWindow(title: 'Munna Rent Services'),
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
              // circles: _createCircles(), // Add the circles
              myLocationEnabled: true,
              // onTap: _onMapTap,
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
