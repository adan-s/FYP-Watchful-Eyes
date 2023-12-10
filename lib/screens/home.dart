import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var location = Location();
      LocationData userLocation = await location.getLocation();
      print("User Location: $userLocation");
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GoogleMap(
        initialCameraPosition: currentLocation != null
            ? CameraPosition(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          zoom: 14.0,
        )
            : CameraPosition(
          target: LatLng(0, 0),
          zoom: 2.0,
        ),
        myLocationEnabled: true,
        compassEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: currentLocation != null
            ? {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            infoWindow: InfoWindow(
              title: 'Your Location',
              snippet:
              'Lat: ${currentLocation!.latitude}, Lng: ${currentLocation!.longitude}',
            ),
          ),
        }
            : Set<Marker>(),
      ),
    );
  }
}
