import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/CommunityForumPostsAdmin.dart';
import 'package:fyp/screens/analyticsandreports.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/home.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/usermanagement.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../authentication/authentication_repo.dart';
import 'Addcontact.dart';
import 'CrimeDataPage.dart';
import 'blogs.dart';
import 'login_screen.dart';
import 'map.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  GoogleMapController? _controller;
  Set<Marker>? _markers;

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    Set<Marker> markers = await _buildMarkers();
    setState(() {
      _markers = markers;
    });
  }

  Future<Set<Marker>> _buildMarkers() async {
    Set<Marker> markers = {};
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('crimeData').get();
    List<Map<String, dynamic>> crimeData =
    querySnapshot.docs.map((doc) => doc.data()).toList();

    // Map to store the count of crimes per city
    Map<String, int> cityCrimeCount = {};

    // Iterate through crime data to calculate count per city
    for (var crime in crimeData) {
      double lat = crime['location']['latitude'];
      double lng = crime['location']['longitude'];
      String? city = await _fetchCity(lat, lng);
      if (city != null) {
        cityCrimeCount[city] = (cityCrimeCount[city] ?? 0) + 1;
      }
    }

    // Create markers for each city with crime count
    for (var entry in cityCrimeCount.entries) {
      String city = entry.key;
      int count = entry.value;

      LatLng? position = await _getCityPosition(city);
      if (position != null) {
        markers.add(
          Marker(
            markerId: MarkerId(city),
            position: position,
            infoWindow: InfoWindow(
              title: city,
              snippet: 'Crime Count: $count',
            ),
          ),
        );
      }
    }

    return markers;
  }

  Future<LatLng?> _getCityPosition(String city) async {
    final apiKey = 'AIzaSyC_U0sxKqJJesyY297XStbt8Z9mIWXbP9U';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$city&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK') {
          final results = jsonData['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final geometry = results[0]['geometry'];
            final location = geometry['location'];
            double lat = location['lat'];
            double lng = location['lng'];
            return LatLng(lat, lng);
          }
        }
      }
    } catch (e) {
      print('Error fetching city position: $e');
    }
    return null;
  }

  Future<String?> _fetchCity(double lat, double lng) async {
    final apiKey = 'AIzaSyC_U0sxKqJJesyY297XStbt8Z9mIWXbP9U';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK') {
          final results = jsonData['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final addressComponents =
                results[0]['address_components'] as List<dynamic>;
            for (var component in addressComponents) {
              final types = component['types'] as List<dynamic>;
              if (types.contains('locality')) {
                return component['long_name'];
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching city: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Admin Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
                Color(0xFF7EA3CA),
                Color(0xFF769DC9),
                Color(0xFFCBE1EE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF769DC9),
                      Color(0xFF769DC9),
                      Color(0xFF7EA3CA),
                      Color(0xFF769DC9),
                      Color(0xFFCBE1EE),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: GestureDetector(
                        child: Image.asset(
                          "assets/admin.png",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Watchful Eyes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: Colors.white),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                  );
                },
              ),
              Divider(
                color: Colors.white,
              ),
              if (kIsWeb)
                ListTile(
                  leading:
                      Icon(Icons.supervised_user_circle, color: Colors.white),
                  title: Text(
                    'User Management',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserManagement()),
                    );
                  },
                ),
              if (kIsWeb)
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.white),
                  title: Text(
                    'Analytics and Reports',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyticsAndReports()),
                    );
                  },
                ),
              if (kIsWeb)
                Divider(
                  color: Colors.white,
                ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.check, color: Colors.white),
                  title: Text(
                    'Community Forum Posts',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityForumPostsAdmin()),
                    );
                  },
                ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.warning, color: Colors.white),
                  title: Text(
                    'Registered Complaints',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrimeDataPage()),
                    );
                  },
                ),
              if (!kIsWeb)
                Divider(
                  color: Colors.white,
                ),
              GestureDetector(
                onTap: () async {
                  bool confirmLogout =
                      await _showLogoutConfirmationDialog(context);

                  if (confirmLogout) {
                    await AuthenticationRepository.instance.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.white),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF769DC9),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
              Color(0xFFCBE1EE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Display Total Number of Users and Registered Complaints
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Total Number of Users Card
                Expanded(
                  child: Card(
                    elevation: 5.0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFCBE1EE),
                            Color(0xFF769DC9),
                            Color(0xFF7EA3CA),
                            Color(0xFF769DC9),
                            Color(0xFFCBE1EE),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            (kIsWeb) ? 'Total Number of Users' : 'Total Users',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          // Fetch and display the total number of users
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }

                              int totalUsers = snapshot.data!.docs.length;
                              return Text(
                                '$totalUsers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Total Registered Cases Card
                Expanded(
                  child: Card(
                    elevation: 5.0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFCBE1EE),
                            Color(0xFF769DC9),
                            Color(0xFF7EA3CA),
                            Color(0xFF769DC9),
                            Color(0xFFCBE1EE),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            (kIsWeb)
                                ? 'Total Registered Cases'
                                : 'Registered Cases',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          // Fetch and display the total number of registered cases
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('crimeData')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              int totalRegisteredCases =
                                  snapshot.data!.docs.length;
                              return Text(
                                '$totalRegisteredCases',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _controller = controller;
                  });
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 11.0,
                ),
                myLocationEnabled: true,
                markers: _markers ?? {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logout Confirmation'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true); // Yes, logout

                    // Perform logout
                    await AuthenticationRepository.instance.logout();

                    // Redirect to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child:
                      const Text('Yes', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child:
                      const Text('No', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
