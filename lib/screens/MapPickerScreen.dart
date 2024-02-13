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
        title: Text('Pick Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _currentLocationController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Current Location',
                labelStyle: TextStyle(
                  fontFamily: 'outfit',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              enabled: false, // Make the text field uneditable
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.pop(context, _selectedLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
