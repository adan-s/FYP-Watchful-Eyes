import 'package:flutter/material.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  GoogleMapController? _controller;

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
      // You may want to show a dialog explaining why location is necessary
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission
      // You may want to show a dialog explaining why location is necessary
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied location permission
      // You may want to show a dialog explaining why location is necessary
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocationController.text =
        '${position.latitude}, ${position.longitude}';
      });

      _showMap(position.latitude, position.longitude);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showMap(double latitude, double longitude) async {
    try {
      LatLng currentLatLng = LatLng(latitude, longitude);

      // Move camera to the user's current location
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000104),
                Color(0xFF0E121B),
                Color(0xFF141E2C),
                Color(0xFF18293F),
                Color(0xFF193552),
              ],
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Map',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          ResponsiveAppBarActions(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF000104),
              Color(0xFF0E121B),
              Color(0xFF141E2C),
              Color(0xFF18293F),
              Color(0xFF193552),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _currentLocationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Location',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                enabled: false, // Make the text field uneditable
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _destinationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Destination',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_destinationController.text.isNotEmpty) {
                    // Handle the case where a destination is entered
                    // You can implement the logic to show the route on the map
                  } else {
                    // Show the map with the current location if no destination is entered
                    _getCurrentLocation();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF000104), Color(0xFF0E121B), Color(0xFF141E2C), Color(0xFF18293F), Color(0xFF000104)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(width: 8),
                      Text(
                        "Show Map",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(0, 0),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ResponsiveAppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: [
        _buildNavBarItem("Home", Icons.home, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserPanel()),
          );
        }),
        _buildNavBarItem("Community Forum", Icons.group, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityFormPage()),
          );
        }),
        _buildNavBarItem("Map", Icons.map, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapPage()),
          );
        }),
        _buildNavBarItem("Safety Directory", Icons.book, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SafetyDirectory()),
          );
        }),
        _buildNavBarItem("Crime Registeration", Icons.report, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CrimeRegistrationForm()),
          );
        }),
        _buildIconButton(
          icon: Icons.person,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: title,
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  ResponsiveRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600)
          ...children.map((child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          )),
        if (MediaQuery.of(context).size.width <= 600)
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return children
                  .map((child) => PopupMenuItem(
                child: child,
              ))
                  .toList();
            },
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: Colors.black,
          ),
      ],
    );
  }
}