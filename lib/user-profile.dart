import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'community-forum.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Dummy data
  int numberOfCrimesRegistered = 5;
  int numberOfPostsShared = 10;
  String username = 'John Doe';
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crimes Registered: $numberOfCrimesRegistered',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posts Shared: $numberOfPostsShared',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showEditProfileDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
            ),
          ),
        ),
      ),
    );
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
                // Add logic to update the name
                String newName = nameController.text;
                // Update the user's name and close the dialog
                setState(() {
                  username = newName;
                });
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

  void _updateProfileImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // Add logic to update the profile image
      // You can upload the image to a server or use it locally
      setState(() {
        profileImageUrl = imageFile.path;
      });
    }

    Navigator.of(context).pop();
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  ResponsiveRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600)
          ...children.map((child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          )),
        if (MediaQuery.of(context).size.width <= 600)
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return children
                  .map((child) => PopupMenuItem(
                child: child,
              ))
                  .toList();
            },
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: Colors.black,
          ),
      ],
    );
  }
}
