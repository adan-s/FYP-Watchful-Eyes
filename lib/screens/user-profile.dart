import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/authentication/controllers/profile_controller.dart';
import 'package:fyp/authentication/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'map.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  final Completer<void> _updateProfileCompleter = Completer<void>();

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
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
            ),
          ),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          ResponsiveAppBarActions(),
        ],
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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                          fontFamily: 'outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(
                          fontFamily: 'outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          _showEditProfileDialog(context, user.email, snapshot);
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
                            color: Colors.white,
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
                                  fontFamily: 'outfit',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.black,
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
  Future<void> _handleUpdateProfile(String username, String contactNo, AsyncSnapshot<usermodel> snapshot) async {
    try {
      if (snapshot.data == null) {
        // Handle the case where user data is not available
        print(snapshot.data);
        print('User data not found. Cannot update profile.');
        return;
      }

      final user = snapshot.data;
      String userEmail = user?.email ?? '';
      print(userEmail);

      // Update user information in Firestore
      await controller.updateUserData(
        email: userEmail,
        UserName: username,
        ContactNo: contactNo,
      );

      // Show success message
      _showAlertDialog(
        'Success',
        'Profile updated successfully!',
        Colors.green,
      );

      // Move back to user profile page
      Navigator.of(context).pop();

      // Complete the Future when the dialog is dismissed
      _updateProfileCompleter.complete();
    } catch (e) {
      _showAlertDialog(
        'Error',
        'Error Updating Profile!',
        Colors.red,
      );
    }
  }

  void _showAlertDialog(String title, String message, Color backgroundColor) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: backgroundColor,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // Complete the Future when the dialog is dismissed
                _updateProfileCompleter.complete();
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    // Return the Future to wait for the dialog to be dismissed
    return _updateProfileCompleter.future;
  }

  void _showEditProfileDialog(BuildContext context, String userEmail,
      AsyncSnapshot<usermodel> snapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Update Profile'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _showEditNameDialog(context, snapshot);
              },
              child: const Text('Update Name'),
            ),
            SimpleDialogOption(
              onPressed: () {
                _updateProfileImage(context, snapshot);
              },
              child: const Text('Update Profile Image'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNameDialog(
      BuildContext context, AsyncSnapshot<usermodel> snapshot) {
    TextEditingController nameController = TextEditingController();
    TextEditingController contactNoController = TextEditingController();

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
                bool confirmed = await _showConfirmationDialog(context);
                if (confirmed) {
                  await _handleUpdateProfile(
                    nameController.text,
                    contactNoController.text,
                    snapshot,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to update?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ) ??
        false; // Return false if the dialog is dismissed
  }

  Future<void> _updateProfileImage(
      BuildContext context, AsyncSnapshot<usermodel> snapshot) async {
    try {
      dynamic imageFile;

      final ImagePicker _picker = ImagePicker();
      imageFile = await _picker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        String imageUrl = '';
        Uint8List data;

        if (imageFile is File) {
          data = await imageFile.readAsBytes();
        } else if (imageFile is XFile) {
          data = await imageFile.readAsBytes();
        } else {
          throw Exception("Unsupported image file type");
        }

        final user = snapshot.data;

        if (user != null) {
          String userEmail = user.email ?? '';
          final metadata = SettableMetadata(contentType: 'image/*');
          final storageRef = FirebaseStorage.instance.ref();

          firebase_storage.UploadTask? uploadTask;

          uploadTask = storageRef
              .child("uploadImage/$userEmail.jpeg")
              .putData(data, metadata);

          bool confirmed = await _showConfirmationDialog(context);
          if (confirmed) {
            await uploadTask!.whenComplete(() async {
              imageUrl = await storageRef
                  .child("uploadImage/$userEmail.jpeg")
                  .getDownloadURL();
              await controller.updateProfileImage(
                  email: userEmail, imageUrl: imageUrl);
              setState(() {
                profileImageUrl = imageUrl;
              });

              // Show success message
              _showAlertDialog(
                'Success',
                'Image uploaded successfully!',
                Colors.green,
              );

              // Move back to user profile page
              Navigator.of(context).pop();
            });
          }
        } else {
          print('User data is null. Cannot upload image.');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Handle the error as needed
      _showAlertDialog(
        'Error',
        'Failed to upload profile image. Please try again.',
        Colors.red,
      );
    }
  }
}
