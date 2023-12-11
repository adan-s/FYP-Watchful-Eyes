import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/usermanagement.dart';

class AdminDashboard extends StatelessWidget {
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
              title: Text('Profile', style: TextStyle(fontFamily: 'outfit', color: Colors.white)),
              onTap: () {
                // Handle the Profile option
                Navigator.pop(context); // Close the menu
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout', style: TextStyle(fontFamily: 'outfit', color: Colors.white)),
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
          style: TextStyle(fontFamily: 'outfit', color: Colors.white),
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
            // ... (Navigate to Community Forum page)
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Map", Icons.map, () {
            // ... (Navigate to Map page)
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Safety Directory", Icons.book, () {
            // ... (Navigate to Safety Directory page)
          }),
          SizedBox(width: 8),
          _buildNavBarItem("Crime Registration", Icons.report, () {
            // ... (Navigate to Crime Registration page)
          }),
          SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.person,
            onPressed: () {
              // ... (Navigate to User Profile page)
            },
          ),
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
                            fontFamily: 'outfit',
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            fontFamily: 'outfit',
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
                    fontFamily: 'outfit',
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
                    fontFamily: 'outfit',
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
                    fontFamily: 'outfit',
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
                    fontFamily: 'outfit',
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
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'outfit',
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // ... (Handle Logout action)
                  Navigator.pop(context);
                },
              ),
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: '  Search...',
                          hintStyle: TextStyle(fontFamily: 'outfit',color: Colors.grey),
                          suffixIcon: Icon(Icons.search, color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 24,
                            maxWidth: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: GestureDetector(
                      onTapDown: (details) {
                        _showProfileMenu(context, details.globalPosition);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/admin.png"),
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
                              fontFamily: 'outfit',
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
                                return Text('0',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ));
                              }

                              int totalUsers = snapshot.data!.docs.length;
                              return Text(
                                '$totalUsers',
                                style: TextStyle(
                                  fontFamily: 'outfit',
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
                // ... (existing code)
              ],
            ),
            // ... (existing code)
          ],
        ),
      ),
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
