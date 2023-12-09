import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/authentication/controllers/profile_controller.dart';
import 'package:fyp/authentication/models/user_model.dart';

import 'community-forum.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  String profileImageUrl =
      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

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
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Center(
              child: FutureBuilder<usermodel>(
                future: controller.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('User data not found.'));
                  }

                  final user = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Username: ${user.username}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          _showEditProfileDialog(context, user.email);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF000104),
                                Color(0xFF0E121B),
                                Color(0xFF141E2C),
                                Color(0xFF18293F),
                                Color(0xFF000104),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleUpdateProfile(String username, String contactNo) async {
    try {
      // Check if the new username and contactNo are unique in the database
      bool isUsernameUnique = await controller.isUsernameUnique(username);
      bool isContactNoUnique = await controller.isContactNoUnique(contactNo);

      if (!isUsernameUnique) {
        // Handle the case where the username is not unique
        print('Username is not unique. Please choose another one.');
        return;
      }

      if (!isContactNoUnique) {
        // Handle the case where the contact number is not unique
        print('Contact number is not unique. Please choose another one.');
        return;
      }

      // Proceed with the update
      User? currentUser = FirebaseAuth.instance.currentUser;
      String userEmail = currentUser?.email ?? ''; // Get user's email

      // Update user information in Firestore
      await controller.updateUserData(
        email: userEmail, // Pass user's email
        username: username,
        contactNo: contactNo,
      );

      // Refresh user data
      await controller.getUserData();
    } catch (e) {
      print('Error updating profile: $e');
      // Handle the error as needed
    }
  }

  void _showEditProfileDialog(BuildContext context, String userEmail) {
    TextEditingController nameController = TextEditingController();
    TextEditingController contactNoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showEditNameDialog(
                        context, nameController, contactNoController);
                  },
                  child: const Text('Edit Name'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Choose your desired button color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showEditProfileImageDialog(context);
                  },
                  child: const Text('Edit Profile Image'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Choose your desired button color
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context,
      TextEditingController nameController,
      TextEditingController contactNoController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _handleUpdateProfile(
                  nameController.text,
                  contactNoController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Choose your desired button color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileImageDialog(BuildContext context) {
    // Implement code to allow the user to choose a new profile image
    // You can use the image_picker package or any other image picking method here
    print('Editing Profile Image...');
    Navigator.of(context).pop(); // Close the dialog
  }
}