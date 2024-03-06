import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../authentication/authentication_repo.dart';
import 'AddContact.dart';
import 'blogs.dart';
import 'login_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  GoogleMapController? _controller;
  LatLng? _selectedDestination;
  Set<Circle> _circles = {};
  List<Marker> _markers = [];
  Set<Polyline> _polylines = {};



  void _drawCircle(double latitude, double longitude) {
    setState(() {
      _circles.clear();
      _circles.add(
        Circle(
          circleId: CircleId('2km_boundary'),
          center: LatLng(latitude, longitude),
          radius: 2000, // Radius in meters for a 2km boundary
          fillColor: Colors.transparent,
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
    });
  }


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

  //---------------------------------------------------------//
  Future<void> _showMap(double latitude, double longitude) async {
    try {
      LatLng currentLatLng = LatLng(latitude, longitude);

      print('i am in show map');
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 10.0),
      );
    } catch (e) {
      print('Error showing map: $e');
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

      _drawCircle(position.latitude, position.longitude);

      print('i am in current location');
      _showMap(position.latitude, position.longitude);

      // If destination is set, show path and crime information
      if (_destinationController.text.isNotEmpty) {
        _showPath(
          position.latitude,
          position.longitude,
          _destinationController.text,
        );

        // Fetch crime data for the current location
        int crimeCount = await _fetchCrimeData(LatLng(position.latitude, position.longitude));

        // Display crime count for the current location
        if (crimeCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Crime count at current location: $crimeCount'),
            ),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> _showPath(
      double startLatitude, double startLongitude, String destination) async {
    try {
      List<LatLng> points =
          await _getDirections(startLatitude, startLongitude, destination);

      _polylines.clear();
      int routeNumber = 1;

      // Add polyline to the set with a unique PolylineId
      for (int i = 0; i < points.length - 1; i++) {
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId(
                  'path_$routeNumber${_polylines.length + 1}_${i + 1}'),
              points: [points[i], points[i + 1]],
              color: Colors.red,
              width: 5,
            ),
          );
        });

        routeNumber++;
      }

      print('routes: ${routeNumber}');
      print('_polylines size: ${_polylines.length}');
    } catch (e) {
      print('Error showing path: $e');
    }
  }

  void _addMarker(LatLng location, String name, int crimeCount) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: location,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Crime Count: $crimeCount',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }


  Future<List<LatLng>> _getDirections(
      double startLatitude, double startLongitude, String destination) async {
    final apiKey = 'AIzaSyC_U0sxKqJJesyY297XStbt8Z9mIWXbP9U';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatitude,$startLongitude&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<LatLng> points =
          _decodePolyline(decoded['routes'][0]['overview_polyline']['points']);
      return points;
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<void> _showPathFromCurrentToDestination() async {
    if (_controller != null) {
      final currentLocation = _currentLocationController.text;
      final destination = _destinationController.text;

      if (currentLocation.isNotEmpty && destination.isNotEmpty) {
        final currentLatLng = LatLng(
          double.parse(currentLocation.split(', ')[0]),
          double.parse(currentLocation.split(', ')[1]),
        );

        final destinationLatLng = LatLng(
          double.parse(destination.split(', ')[0]),
          double.parse(destination.split(', ')[1]),
        );

        // Fetch crime data for the destination
        int crimeCount = await _fetchCrimeData(destinationLatLng);

        // Calculate distance between current location and destination
        double distance = Geolocator.distanceBetween(
          currentLatLng.latitude,
          currentLatLng.longitude,
          destinationLatLng.latitude,
          destinationLatLng.longitude,
        );

        if (distance > 2000) {
          _destinationController.text = ' ';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Oops! Destination is out of bounds. Enter a destination within 2 km.',
              ),
            ),
          );
        } else {
          _showPath(
            currentLatLng.latitude,
            currentLatLng.longitude,
            destinationLatLng.latitude.toStringAsFixed(7) +
                ', ' +
                destinationLatLng.longitude.toStringAsFixed(7),
          );

          // Display crime count if crimes exist at the destination
          if (crimeCount > 0) {
            // Display crime information using an info window on the map
            _controller?.showMarkerInfoWindow(MarkerId('destination'));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Crime count at destination: $crimeCount'),
              ),
            );
          }
        }
      }
    }
  }

  Future<int> _fetchCrimeData(LatLng destinationLatLng) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a GeoPoint from destinationLatLng
      GeoPoint geoPoint = GeoPoint(destinationLatLng.latitude, destinationLatLng.longitude);


      QuerySnapshot querySnapshot = await firestore
          .collection('crimeData')
          .where('location', isLessThan: geoPoint, isGreaterThan: geoPoint)
          .get();

      print('size:');
      print(querySnapshot.size);

      return querySnapshot.size;
    } catch (e) {
      print("Error fetching crime data: $e");

      return 0;
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    var list = polyline.codeUnits;
    var index = 0;
    var lat = 0;
    var lng = 0;
    List<LatLng> coordinates = [];

    while (index < list.length) {
      var b;
      var shift = 0;
      var result = 0;

      do {
        b = list[index] - 63;
        result |= (b & 0x1F) << (shift * 5);
        shift++;
        index++;
      } while (b >= 0x20);

      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = list[index] - 63;
        result |= (b & 0x1F) << (shift * 5);
        shift++;
        index++;
      } while (b >= 0x20);

      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      var latitude = lat / 1e5;
      var longitude = lng / 1e5;

      coordinates.add(LatLng(latitude, longitude));
    }

    return coordinates;
  }

  void _displayNearbyPlacesInfo() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch nearby hospitals and police stations for the current location
      List<Place> hospitals = await _getNearbyPlaces(
          position.latitude, position.longitude, 'hospital');
      List<Place> policeStations = await _getNearbyPlaces(
          position.latitude, position.longitude, 'police');

      // Display the information in a styled dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF769DC9),
            title: Text(
              "Nearby Emergency Places",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategory("Hospitals", hospitals),
                  SizedBox(height: 16),
                  _buildCategory("Police Stations", policeStations),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error displaying nearby places info: $e");
    }
  }

  Widget _buildCategory(String category, List<Place> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (var place in places)
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${place.name} - ${place.vicinity}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: place.phone != null && place.phone!.isNotEmpty
                    ? Text(
                  "Phone: ${place.phone}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onLocationSelected(place);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Show on Map",
                      style: TextStyle(
                        fontFamily: 'outfit',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  void _onLocationSelected(Place selectedPlace) {
    setState(() {
      _destinationController.text =
      '${selectedPlace.location.latitude}, ${selectedPlace.location.longitude}';
      _selectedDestination = selectedPlace.location;
    });

    Future<int> crimeCount =  _fetchCrimeData(selectedPlace.location);

    _addMarker(selectedPlace.location, selectedPlace.name, crimeCount as int);

    _showPathFromCurrentToDestination();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Map',
              style: TextStyle(fontFamily: 'outfit', color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          ResponsiveAppBarActions(),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF769DC9),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
              Color(0xFFCBE1EE),
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
                  labelStyle: TextStyle(
                      fontFamily: 'outfit', fontSize: 24, color: Colors.white),
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
                style: TextStyle(fontFamily: 'outfit', color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Destination',
                  labelStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                enabled: false,
              ),
              if (_selectedDestination == null)
                Text(
                  'Select dest through marker on map',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_destinationController.text.isNotEmpty) {
                    _showPathFromCurrentToDestination();
                  } else {
                    _getCurrentLocation();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFFFF),
                        Color(0xFFFFFF),
                      ],
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
                        style: TextStyle(
                            fontFamily: 'outfit',
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _displayNearbyPlacesInfo();
                },
                child: Text(
                  "Show Nearby Places Info",
                  style: TextStyle(
                    fontFamily: 'outfit',
                    fontSize: 16,
                    color: Colors.black,
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
                  polylines: _polylines,
                  circles: _circles,
                  onTap: (LatLng point) {
                    setState(() {
                      _selectedDestination = point;
                      _destinationController.text =
                      '${point.latitude}, ${point.longitude}';
                    });
                  },
                  markers: _selectedDestination != null
                      ? {
                    Marker(
                      markerId: MarkerId('destination'),
                      position: _selectedDestination!,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: InfoWindow(
                        title: 'Destination',
                        snippet: 'Selected Destination',
                      ),
                    ),
                  }
                      : Set<Marker>.from(_markers),
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
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Community Forum", Icons.group, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CommunityForumPage()),
            );
          }),
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Emergency Contact", Icons.phone, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  AddContact()),
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
            MaterialPageRoute(
                builder: (context) => const CrimeRegistrationForm()),
          );
        }),
        _buildNavBarItem("Blogs", Icons.newspaper, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BlogPage()),
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
        _buildNavBarItem("Logout", Icons.logout, () async {
          bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("Logging out..."),
                    ],
                  ),
                );
              },
              barrierDismissible: false,
            );

            try {
              await AuthenticationRepository.instance.logout();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } catch (e) {
              print("Logout error: $e");
              Navigator.pop(context);
            }
          }
        }),
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: title,
    ): Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Color(0xFF769DC9)),
          onPressed: onPressed,
          tooltip: title,
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            title,
            style: TextStyle(color: Color(0xFF769DC9)),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ): InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: Color(0xFF769DC9)),
            onPressed: null, // Disable IconButton onPressed
            tooltip: "User Profile",
          ),
          Text(
            "User Profile",
            style: TextStyle(color: Color(0xFF769DC9)),
          ),
        ],
      ),
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
            icon: Icon(Icons.menu, color: Colors.white),
            color: Colors.white,
          ),
      ],
    );
  }
}

Future<List<Place>> _getNearbyPlaces(double latitude, double longitude, String type) async {
  final apiKey = 'AIzaSyC_U0sxKqJJesyY297XStbt8Z9mIWXbP9U'; // Replace with your API key
  final radius = 2000;

  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    List<Place> places = _parsePlaces(decoded['results']);
    print('Nearby Places: $places');
    return places;
  } else {
    throw Exception('Failed to load nearby places');
  }
}


List<Place> _parsePlaces(List<dynamic> results) {
  return results.map((place) {
    return Place(
      name: place['name'],
      vicinity: place['vicinity'],
      phone: place['formatted_phone_number'] ?? '',
      location: LatLng(
        place['geometry']['location']['lat'],
        place['geometry']['location']['lng'],
      ),
    );
  }).toList();
}


class Place {
  final String name;
  final String vicinity;
  final String? phone;
  final LatLng location;

  Place({required this.name, required this.vicinity, this.phone, required this.location});
}
