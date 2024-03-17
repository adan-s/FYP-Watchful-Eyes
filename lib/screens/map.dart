import 'dart:math';

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
import 'package:intl/intl.dart';
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
  List<CrimeData?> crimeDataList = [];
  late Position position;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchCrimeData();
  }

  Future<void> _fetchCrimeData() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    crimeDataList = await _fetchAllCrimeData();
    setState(() {});
  }

  Set<Marker> _getMarkers() {
    Set<Marker> markers = Set<Marker>.from(_markers);

    // Add destination marker
    if (_selectedDestination != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: _selectedDestination!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: 'Selected Destination',
          ),
        ),
      );
    }

    _fetchCrimeData();

    if (position != null) {
      // Check if position is not null
      for (CrimeData? crimeData in crimeDataList) {
        if (crimeData != null) {
          double distance = _calculateDistance(
            LatLng(position.latitude!, position.longitude!),
            LatLng(crimeData.latitude, crimeData.longitude),
          );

          if (distance <= 2.0) {
            _addMarker(crimeData);
          }
        }
      }
    } else {
      print('Position is null. Crime data cannot be fetched.');
    }

    return markers;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const int radiusOfEarth = 6371;

    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _addMarker(CrimeData? crimeData) {
    if (crimeData != null) {
      String markerId = 'crime_${crimeData.latitude}_${crimeData.longitude}';

      // Check if the registered case is anonymous
      String snippetContent;
      if (crimeData.isAnonymous) {
        snippetContent = 'Anonymous Case';
      } else {
        // If not anonymous, show person name
        snippetContent = 'Reported by: ${crimeData.fullName}';
      }

      BitmapDescriptor markerIcon;

      // Choose marker color based on crime type
      switch (crimeData.crimeType) {
        case "Other":
          markerIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
          break;
        case "Domestic Abuse":
          markerIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
          break;
        case "Harrasement":
          markerIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        case "Accident":
          markerIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        default:
          markerIcon = BitmapDescriptor.defaultMarker;
      }

      Marker newMarker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(crimeData.latitude, crimeData.longitude),
        icon: markerIcon,
        onTap: () {
          _showCustomInfoWindow(crimeData);
        },
      );

      setState(() {
        _markers.add(newMarker);
      });
    }
  }

  Widget _getMap() {
    if (position == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
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
        markers: _getMarkers(),
      );
    }
  }

  void _showCustomInfoWindow(CrimeData crimeData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Crime Type: ${crimeData.crimeType}',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crimeData.isAnonymous
                      ? 'Anonymous Case'
                      : 'Reported by: ${crimeData.fullName}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Date: ${crimeData.date}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Time: ${crimeData.time}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.red,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _drawCircle(double latitude, double longitude) {
    setState(() {
      _circles.clear();
      _circles.add(
        Circle(
          circleId: CircleId('2km_boundary'),
          center: LatLng(latitude, longitude),
          radius: 2000,
          // Radius in meters for a 2km boundary
          fillColor: Colors.transparent,
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
    });
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

        double distance = _calculateDistance(currentLatLng, destinationLatLng);

        if (distance <= 2.0) {
          _showPath(
            currentLatLng.latitude,
            currentLatLng.longitude,
            '${destinationLatLng.latitude.toStringAsFixed(7)}, ${destinationLatLng.longitude.toStringAsFixed(7)}',
          );
        } else {
          _showPath(
            currentLatLng.latitude,
            currentLatLng.longitude,
            '${currentLatLng.latitude.toStringAsFixed(7)}, ${currentLatLng.longitude.toStringAsFixed(7)}',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Oops! Destination is out of bounds (2km).',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<List<CrimeData?>> _fetchAllCrimeData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('crimeData').get();

      List<CrimeData?> crimeDataList = querySnapshot.docs
          .map((doc) {
            Map<String, dynamic> crimeDataMap =
                doc.data() as Map<String, dynamic>;

            if (crimeDataMap.containsKey('location') &&
                crimeDataMap['location'] != null) {
              double latitude = crimeDataMap['location']['latitude'];
              double longitude = crimeDataMap['location']['longitude'];
              String crimeType = crimeDataMap['crimeType'];
              String fullName = crimeDataMap['fullName'];
              bool isAnonymous = crimeDataMap['isAnonymous'] ?? false;
              String date = crimeDataMap['date'];
              String time = crimeDataMap['time'];

              return CrimeData(
                latitude: latitude,
                longitude: longitude,
                crimeType: crimeType,
                fullName: fullName,
                isAnonymous: isAnonymous,
                date: date,
                time: time,
              );
            } else {
              print("Warning: 'location' map is missing or null in crime data");
              return null;
            }
          })
          .where((crimeData) => crimeData != null)
          .toList();

      return crimeDataList;
    } catch (e) {
      print("Error fetching all crime data: $e");
      return [];
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
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.red, fontSize: 12),
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

    _showPathFromCurrentToDestination();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          leading: ResponsiveAppBarActions(),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            Container(
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
              child: Stack(
                children: [
                  Padding(
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
                                fontFamily: 'outfit',
                                fontSize: 24,
                                color: Colors.white),
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
                          style: TextStyle(
                              fontFamily: 'outfit', color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Destination',
                            labelStyle: TextStyle(
                                fontFamily: 'outfit', color: Colors.white),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_destinationController.text.isNotEmpty) {
                                  _showPathFromCurrentToDestination();
                                } else {
                                  _getCurrentLocation();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Show Map",
                                      style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.map,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _displayNearbyPlacesInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Nearby Places",
                                      style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.place,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _getMap(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text("Marker Color Explanations"),
                                  ),
                                ],
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildInfoRow(
                                    Icons.location_on,
                                    "Destination",
                                    "Blue Marker",
                                  ),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    "Other Crimes",
                                    "Yellow Markers",
                                  ),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    "Domestic Abuse",
                                    "Pink Markers",
                                  ),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    "Harassment",
                                    "Red Markers",
                                  ),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    "Accident",
                                    "Red Markers",
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(IconData icon, String title, String description) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.black,
      ),
      SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
          ),
        ],
      ),
    ],
  );
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
              MaterialPageRoute(builder: (context) => AddContact()),
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
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
            tooltip: title,
          )
        : Row(
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
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          )
        : InkWell(
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

Future<List<Place>> _getNearbyPlaces(
    double latitude, double longitude, String type) async {
  final apiKey =
      'AIzaSyC_U0sxKqJJesyY297XStbt8Z9mIWXbP9U'; // Replace with your API key
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

  Place(
      {required this.name,
      required this.vicinity,
      this.phone,
      required this.location});
}

class CrimeData {
  double latitude;
  double longitude;
  String crimeType;
  String fullName;
  bool isAnonymous;
  String date;
  String time;

  CrimeData({
    required this.latitude,
    required this.longitude,
    required this.crimeType,
    required this.fullName,
    required this.isAnonymous,
    required this.date,
    required this.time,
  });
}
