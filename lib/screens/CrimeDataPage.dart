import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/admindashboard.dart';
import 'package:fyp/screens/usermanagement.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authentication/authentication_repo.dart';
import 'CommunityForumPostsAdmin.dart';
import 'CrimeDetailPage.dart';
import 'analyticsandreports.dart';
import 'login_screen.dart';

class CrimeDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Registered Complaints ',
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF769DC9),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
              Color(0xFFCBE1EE),
            ],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchCrimeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<Map<String, dynamic>> crimeDataList = snapshot.data ?? [];

            return ListView.builder(
              itemCount: crimeDataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> crimeData = crimeDataList[index];
                return CrimeDataCard(
                  crimeData: crimeData,
                  userEmail: '',
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchCrimeData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('crimeData').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
}

class CrimeDataCard extends StatelessWidget {
  final Map<String, dynamic> crimeData;
  final String userEmail;

  const CrimeDataCard(
      {Key? key, required this.crimeData, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            title: Text(
              'Full Name: ${crimeData['fullName']}',
              style: TextStyle(fontFamily: 'outfit', color: Colors.white),
            ),
            subtitle: Text(
              'Crime Type: ${crimeData['crimeType']}',
              style: TextStyle(fontFamily: 'outfit', color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrimeDetailPage(crimeData: crimeData),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _showStatusUpdateDialog(context),
                  child: Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Update Status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CrimeDetailPage(crimeData: crimeData),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.green,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Show Details',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),
        ]));
  }

  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedStatus = '';
        return AlertDialog(
          title: Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Received'),
                value: 'Received',
                groupValue: selectedStatus,
                onChanged: (value) {
                  selectedStatus = value!;
                  _sendWhatsAppMessage(selectedStatus);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('Being Investigated'),
                value: 'Being Investigated',
                groupValue: selectedStatus,
                onChanged: (value) {
                  selectedStatus = value!;
                  _sendWhatsAppMessage(selectedStatus);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('Case Closed'),
                value: 'Case Closed',
                groupValue: selectedStatus,
                onChanged: (value) {
                  selectedStatus = value!;
                  _sendWhatsAppMessage(selectedStatus);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendWhatsAppMessage(String status) async {
    String phoneNumber = crimeData[
        'phoneNumber']; // Assuming you have 'phoneNumber' in crimeData

    if (phoneNumber.isNotEmpty) {
      String formattedPhoneNumber =
          '+92${phoneNumber.substring(1)}'; // Remove the first zero and add +92
      String message = _constructMessage(status);
      String encodedMessage = Uri.encodeComponent(message);
      String url =
          'whatsapp://send?phone=$formattedPhoneNumber&text=$encodedMessage';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  String _constructMessage(String status) {
    String crimeType = crimeData['crimeType'];
    switch (status) {
      case 'Received':
        return 'Your crime report of $crimeType was received. We will keep you updated.';
      case 'Being Investigated':
        return 'Your crime report of $crimeType was received and is currently being investigated. Please cooperate for the time being. We will keep you updated.';
      case 'Case Closed':
        return 'Your crime report of $crimeType was investigated and the case is closed now. Thank you for your cooperation, hope you had a pleasant experience with us.';
      default:
        return '';
    }
  }
}
