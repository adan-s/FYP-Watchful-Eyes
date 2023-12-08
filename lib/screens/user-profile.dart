import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/authentication/controllers/profile_controller.dart';
import 'package:fyp/authentication/models/user_model.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  String profileImageUrl = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

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
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    _showEditProfileDialog(context);
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
                        colors: [Color(0xFF000104), Color(0xFF0E121B), Color(0xFF141E2C), Color(0xFF18293F), Color(0xFF000104)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    );
  }

  void _updateProfileName(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Name'),
          content: TextField(
            controller: nameController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Enter new name',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _handleUpdateProfileName(nameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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

  void _handleUpdateProfileName(String newName) {
    // Add logic to update the name
    // You can call your controller method or update the UI directly
    // For example: controller.updateUsername(newName);
    setState(() {
      // Update the username in the UI
      // user.username = newName;
    });
  }

  void _updateProfileImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        // Update the profile image in the UI
        profileImageUrl = imageFile.path;
      });
    }

    Navigator.of(context).pop();
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Update Profile'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _updateProfileName(context);
              },
              child: const Text('Update Name'),
            ),
            SimpleDialogOption(
              onPressed: () {
                _updateProfileImage(context);
              },
              child: const Text('Update Profile Image'),
            ),
          ],
        );
      },
    );
  }
}

class ResponsiveAppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your responsive app bar actions here
    return Container(); // Placeholder, replace with your actual app bar actions
  }
}