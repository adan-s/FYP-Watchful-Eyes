import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/screens/admindashboard.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../authentication/authentication_repo.dart';
import 'CommunityForumPostsAdmin.dart';
import 'CrimeDataPage.dart';
import 'login_screen.dart';

class UserManagement extends StatelessWidget {
  final _mailerUsername = 'watchfuleyesmanager@gmail.com'; // Update with your email
  final _mailerPassword = 'asusBOOKfat@123'; // Update with your email password
  @override


  Widget build(BuildContext context) {

    void _sendEmail(String userEmail, String subject, String body) async {
      final smtpServer = gmail(_mailerUsername, _mailerPassword);

      final message = Message()
        ..from = Address(_mailerUsername, 'Admin')
        ..recipients.add(userEmail)
        ..subject = subject
        ..text = body;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (e) {
        print('Error occurred while sending email: $e');
      }
    }

    Widget _buildStatusItem(BuildContext context, String status, String userEmail) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pop();
          // Perform action based on selected status
          switch (status) {
            case 'Received':
              _sendEmail(userEmail, 'Your Report Has Been Received', 'Your report has been received. We will review it shortly.');
              break;
            case 'Being Investigated':
              _sendEmail(userEmail, 'Your Report is being currently investigated', 'Your report is currently being investigated. We will update you with any progress.');
              break;
            case 'Case Closed':
              _sendEmail(userEmail, 'Your Report Has Now Been Closed', 'Your report has been closed. Thank you for your cooperation.');
              break;
            default:
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(status),
        ),
      );
    }

    void _showStatusUpdateDialog(BuildContext context, String userEmail) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusItem(context, 'Received', userEmail),
                _buildStatusItem(context, 'Being Investigated', userEmail),
                _buildStatusItem(context, 'Case Closed', userEmail),
              ],
            ),
          );
        },
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Text(
          'User Management',
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
                  Navigator.pop(context); // Close the drawer
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
                    MaterialPageRoute(
                        builder: (context) => CrimeDataPage()),
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search a User (by email)...',
                          hintStyle: TextStyle(
                              fontFamily: 'outfit', color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.black),
                            onPressed: () async {
                              final email = _searchController.text.trim();

                              if (email.isNotEmpty) {
                                try {
                                  final userSnapshot =
                                  await getUserByUsername(email);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                        ),
                                        child: Container(
                                          width: 300,
                                          // Set your desired width
                                          height: 300,
                                          // Set your desired height
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
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '           User Data Found',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .white, // Add text color as needed
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              UserDataDisplay(
                                                  userSnapshot: userSnapshot),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Close',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)), // Add text color as needed
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
                                        content: Text(
                                            'The user with the given email does not exist.'),
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
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 24,
                            maxWidth: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                            Color(0xFFCBE1EE),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(26.0),
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
                                return Text('0',
                                    style: TextStyle(
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
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found.');
                  }

                  List<DocumentSnapshot> users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index].data() as Map<String, dynamic>;

                      return Card(
                        elevation: 5.0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            'Name: ${user['FirstName']} ${user['LastName']}',
                            style: TextStyle(
                                fontFamily: 'outfit', color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ${user['Email']}',
                                style: TextStyle(
                                    fontFamily: 'outfit', color: Colors.white),
                              ),
                              Text(
                                'Contact No: ${user['ContactNo']}',
                                style: TextStyle(
                                    fontFamily: 'outfit', color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showStatusUpdateDialog(context, user['Email']);
                                },
                                child: Text(
                                  'Update Status',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10), // Add some space between Update Status and Delete icon
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  // Show confirmation dialog before deleting
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Are you sure you want to delete this user?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(true); // Yes, delete
                                            },
                                            child: Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // No, don't delete
                                            },
                                            child: Text('No',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete == true) {
                                    // User confirmed to delete
                                    String userId = users[index].id;
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(userId)
                                        .delete();
                                    // Show Snackbar
                                    Get.snackbar(
                                      "Congratulations",
                                      "User deleted successfully.",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUsername(
      String email) async {
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

  Widget UserDataDisplay(
      {required DocumentSnapshot<Map<String, dynamic>> userSnapshot}) {
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


  Widget _buildStatusItem(BuildContext context, String status) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        // Perform action based on selected status
        switch (status) {
          case 'Received':
          // Update status as received
            break;
          case 'Being Investigated':
          // Update status as being investigated
            break;
          case 'Case Closed':
          // Update status as case closed
            break;
          default:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(status),
      ),
    );
  }
}