import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/screens/blogs.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/authentication/controllers/profile_controller.dart';
import 'package:fyp/authentication/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    fetchProfileImage();
  }

  // Fetch profile image URL from the database
  Future<void> fetchProfileImage() async {
    try {
      final user = await controller.getUserData();
      print(user.profileImage);
      if (user != null && user.profileImage != null) {
        setState(() {
          profileImageUrl = user.profileImage!;
        });
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  final ProfileController controller = Get.put(ProfileController());
  String profileImageUrl =
      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

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
                  Color(0xFF7EA3CA),
                ],
              ),
            ),
          ),
          title: const Text(
            'User Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'outfit',
            ),
          ),
          centerTitle: kIsWeb ? null : true,
          leading: kIsWeb ? null : ResponsiveAppBarActions(),
          actions: kIsWeb ? [ResponsiveAppBarActions()] : null,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Color(0xFF769DC9),
                Color(0xFF7EA3CA),
                Color(0xFF7EA3CA),
                Color(0xFFCBE1EE),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            _showEditProfileDialog(
                                context, user.email, snapshot);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
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
      ),
    );
  }

  Future<void> _handleUpdateProfile(String username, String contactNo,
      AsyncSnapshot<usermodel> snapshot) async {
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

      // Refresh user data
      await controller.getUserData();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating profile: $e');
      // Handle the error as needed
    }
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
              child: const Text('Update Info'),
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
          title: const Text('Edit Info'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    counterText: '',
                    hintText: 'Max 15 characters',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  maxLength: 15,
                ),
                TextField(
                  controller: contactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No',
                    counterText: '',
                    hintText: '11111111111',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.phone, color: Colors.grey),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                bool confirmUpdate = await _showConfirmationDialog(context);
                if (confirmUpdate) {
                  if (contactNoController.text.length == 11 &&
                      nameController.text.isNotEmpty) {
                    await _handleUpdateProfile(
                      nameController.text,
                      contactNoController.text,
                      snapshot,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar(
                      "Error",
                      "Invalid input. Please check username and contact number.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
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
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to update?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm update
              },
              child: const Text('Yes', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Do not update
              },
              child: const Text('No', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
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

          await uploadTask!.whenComplete(() async {
            imageUrl = await storageRef
                .child("uploadImage/$userEmail.jpeg")
                .getDownloadURL();
            await controller.updateProfileImage(
                email: userEmail, imageUrl: imageUrl);
            setState(() {
              profileImageUrl = imageUrl;
              print(profileImageUrl);
            });
            Navigator.of(context).pop(); // Close the dialog box
          });
        } else {
          print('User data is null. Cannot upload image.');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Handle the error as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to upload profile image. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
