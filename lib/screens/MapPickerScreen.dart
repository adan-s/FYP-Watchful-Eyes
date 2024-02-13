import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({Key? key, this.initialLocation}) : super(key: key);

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController _controller;
  LatLng? _selectedLocation;
  TextEditingController _selectedLocationController = TextEditingController();
  TextEditingController _currentLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await _requestLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied location permission
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied location permission
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocationController.text =
        '${position.latitude.toStringAsFixed(7)}, ${position.longitude.toStringAsFixed(7)}';
      });

      _showMap(position.latitude, position.longitude);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showMap(double latitude, double longitude) async {
    try {
      LatLng currentLatLng = LatLng(latitude, longitude);

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 15.0),
      );
    } catch (e) {
      print('Error showing map: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick Location',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Disable the back arrow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF769DC9), // Set background color here
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _currentLocationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Location',
                  labelStyle: TextStyle(
                    fontFamily: 'outfit',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                enabled: false,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF769DC9), // Set background color here
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _selectedLocationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Selected Location',
                  labelStyle: TextStyle(
                    fontFamily: 'outfit',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                enabled: false,
              ),
            ),
          ),

          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: widget.initialLocation ?? const LatLng(0, 0),
                zoom: 15,
              ),
              myLocationEnabled: true,
              onTap: (LatLng point) {
                setState(() {
                  _selectedLocation = point;
                  _selectedLocationController.text =
                  '${point.latitude.toStringAsFixed(7)}, ${point.longitude.toStringAsFixed(7)}';
                });
              },
              markers: _selectedLocation != null
                  ? {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedLocation!,
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(
                    title: 'Selected Location',
                    snippet: 'Tap to confirm',
                  ),
                ),
              }
                  : {},
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only( bottom: 86.0,right: 20.0), // Adjust the left padding as needed
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
            child: Icon(Icons.check),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
