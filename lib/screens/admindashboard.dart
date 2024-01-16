import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/home.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/usermanagement.dart';

import '../authentication/authentication_repo.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Function to show the menu with profile/logout options
    void _showProfileMenu(BuildContext context, Offset tapPosition) async {
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          tapPosition.dx,
          tapPosition.dy,
          tapPosition.dx + 1,
          tapPosition.dy + 1,
        ),
        items: [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the Profile option
                Navigator.pop(context); // Close the menu
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the Logout option
                Navigator.pop(context); // Close the menu
              },
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.black, // Set background color
        elevation: 8.0,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000104),
                Color(0xFF0E121B),
                Color(0xFF141E2C),
                Color(0xFF18293F),
                Color(0xFF193552),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          _buildNavBarItem("Home", Icons.home, () {
            // ... (Navigate to Home page)
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Community Forum", Icons.group, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommunityForumPage()),
            );
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Map", Icons.map, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Safety Directory", Icons.book, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafetyDirectory()),
            );
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Crime Registration", Icons.report, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrimeRegistrationForm()),
            );
          }),

        ],
      ),
      drawer: Drawer(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000104),
                Color(0xFF0E121B),
                Color(0xFF141E2C),
                Color(0xFF18293F),
                Color(0xFF193552),
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
                      Color(0xFF000104),
                      Color(0xFF0E121B),
                      Color(0xFF141E2C),
                      Color(0xFF18293F),
                      Color(0xFF193552),
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
                        onTapDown: (details) {
                          _showProfileMenu(context, details.globalPosition);
                        },
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
                leading: Icon(Icons.supervised_user_circle, color: Colors.white),
                title: Text(
                  'User Management',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
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
                  // ... (Handle Analytics and Reports action)
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(Icons.check, color: Colors.white),
                title: Text(
                  'Post Approval',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // ... (Handle Post Approval action)
                  Navigator.pop(context);
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
                  // ... (Handle Registered Complaints action)
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: Colors.white,
              ),
              GestureDetector(
                onTap: () async {
                  bool confirmLogout = await _showLogoutConfirmationDialog(context);

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
              Color(0xFF000104),
              Color(0xFF0E121B),
              Color(0xFF141E2C),
              Color(0xFF18293F),
              Color(0xFF193552),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth < 600 ? screenWidth - 32 : 250,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '  Search...',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: () async {
                              final email = _searchController.text.trim();

                              if (email.isNotEmpty) {
                                try {
                                  final userSnapshot = await getUserByUsername(email);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Container(
                                          width: 300, // Set your desired width
                                          height: 400, // Set your desired height
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF000104),
                                                Color(0xFF0E121B),
                                                Color(0xFF141E2C),
                                                Color(0xFF18293F),
                                                Color(0xFF193552),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '           User Data Found',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white, // Add text color as needed
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              UserDataDisplay(userSnapshot: userSnapshot),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Close', style: TextStyle(color: Colors.white)), // Add text color as needed
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );




                                } catch (error) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('User Not Found'),
                                        content: Text('The user with the given email does not exist.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display Total Number of Users and Registered Complaints
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
                            Color(0xFF000104),
                            Color(0xFF0E121B),
                            Color(0xFF141E2C),
                            Color(0xFF18293F),
                            Color(0xFF193552),
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
                            'Total Number of Users',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          // Fetch and display the total number of users
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                            Color(0xFF000104),
                            Color(0xFF0E121B),
                            Color(0xFF141E2C),
                            Color(0xFF18293F),
                            Color(0xFF193552),
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
                            'Total Registered Cases',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          // Fetch and display the total number of registered cases
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('Complaints').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Text(
                                  '8',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              int totalRegisteredCases = snapshot.data!.docs.length;
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
            ),Expanded(
              child: Homescreen(),
            ),
            // ... (existing code)
          ],
        ),
      ),
    );

  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUsername(String email) async {
    final userQuery = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();

    if (userQuery.docs.isNotEmpty) {
      return userQuery.docs.first;
    } else {
      return Future.error('User not found');
    }
  }
  Widget UserDataDisplay({required DocumentSnapshot<Map<String, dynamic>> userSnapshot}) {
    final userData = userSnapshot.data();

    return userData != null
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email: ${userData['Email']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          'First Name: ${userData['FirstName']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          'Last Name: ${userData['LastName']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          'UserName: ${userData['UserName']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          'Contact No: ${userData['ContactNo']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          'Dob: ${userData['DOB']}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    )
        : Text('User data not available');
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
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, logout
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

}
