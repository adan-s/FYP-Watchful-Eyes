import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fyp/screens/usermanagement.dart';

import '../authentication/authentication_repo.dart';
import 'CommunityForumPostsAdmin.dart';
import 'CrimeDataPage.dart';
import 'admindashboard.dart';
import 'login_screen.dart';

class AnalyticsAndReports extends StatefulWidget {
  @override
  _AnalyticsAndReportsState createState() => _AnalyticsAndReportsState();
}

class _AnalyticsAndReportsState extends State<AnalyticsAndReports> {
  List<Map<String, dynamic>> _crimeData = [];

  @override
  void initState() {
    super.initState();
    _fetchCrimeData();
  }

  Future<void> _fetchCrimeData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('crimeData').get();
    setState(() {
      _crimeData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  List<charts.Series<Map<String, dynamic>, String>> _prepareData() {
    Map<String, int> crimeCountByType = {};
    _crimeData.forEach((crime) {
      final crimeType = crime['crimeType'];
      crimeCountByType[crimeType] = (crimeCountByType[crimeType] ?? 0) + 1;
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByType.forEach((crimeType, count) {
      chartData.add({'type': crimeType, 'count': count});
    });

    return [
      charts.Series<Map<String, dynamic>, String>(
        id: 'Crime Count',
        data: chartData,
        domainFn: (datum, _) => datum['type'],
        measureFn: (datum, _) => datum['count'].toDouble(),
        insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(fontSize: 0), // Empty TextStyleSpec to remove labels
      ),
    ];
  }

  List<charts.Series<Map<String, dynamic>, DateTime>> _prepareData2() {
    Map<DateTime, int> crimeCountByDate = {};

    // Get the current year
    int currentYear = DateTime.now().year;

    // Create a map with all months of the current year initialized to 0
    for (int i = 1; i <= 12; i++) {
      final monthStart = DateTime(currentYear, i, 1);
      crimeCountByDate[monthStart] = 0;
    }

    // Update the map with actual crime counts for the current year only
    _crimeData.forEach((crime) {
      final dateString = crime['date'];
      final parsedDate = _parseDate(dateString);
      if (parsedDate != null && parsedDate.year == currentYear) {
        final monthStart = DateTime(parsedDate.year, parsedDate.month, 1);
        crimeCountByDate[monthStart] = (crimeCountByDate[monthStart] ?? 0) + 1;
      }
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByDate.forEach((date, count) {
      chartData.add({'date': date, 'count': count});
    });

    return [
      charts.Series<Map<String, dynamic>, DateTime>(
        id: 'Crime Count',
        data: chartData,
        domainFn: (datum, _) => datum['date'],
        measureFn: (datum, _) => datum['count'].toDouble(),
      ),
    ];
  }

  DateTime? _parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $dateString');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Text(
          'Analytics and Reports',
          style: TextStyle(color: Colors.white),
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
              ListTile(
                leading: Icon(Icons.analytics, color: Colors.white),
                title: Text(
                  'Analytics and Reports',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(Icons.check, color: Colors.white),
                title: Text(
                  'Community Forum Posts',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityForumPostsAdmin()),
                  );
                },
              ),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: 400,
                    child: charts.BarChart(
                      _prepareData(),
                      animate: true,
                      vertical: true,
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: 400,
                    child: charts.TimeSeriesChart(
                      _prepareData2(),
                      animate: true,
                      defaultRenderer: charts.BarRendererConfig<DateTime>(),
                      domainAxis: charts.DateTimeAxisSpec(
                        renderSpec:
                            charts.SmallTickRendererSpec(labelRotation: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
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
                onPressed: () {
                  Navigator.of(context).pop(false); // No, do not logout
                },
                child: Text('No'),
              ),
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
                child: Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}
