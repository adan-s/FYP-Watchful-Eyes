import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/map.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';

import '../authentication/controllers/crime_registeration_controller.dart';
import 'blogs.dart';

class CrimeRegistrationForm extends StatefulWidget {
  const CrimeRegistrationForm({super.key});

  @override
  _CrimeRegistrationFormState createState() => _CrimeRegistrationFormState();
}

class _CrimeRegistrationFormState extends State<CrimeRegistrationForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
        title: const Text(
          'Crime Registeration',
          style: TextStyle(fontFamily: 'outfit',color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          ResponsiveAppBarActions(),
        ],
        iconTheme: IconThemeData(color: Colors.white),

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
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFCBE1EE),
                  Color(0xFF769DC9),
                  Color(0xFF7EA3CA),
                  Color(0xFF769DC9),
                  Color(0xFFCBE1EE),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0), // Adjust the space as needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'We are here to help :)',
                        style: TextStyle(
                          fontFamily: 'outfit',
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0), // Adjust the spac
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.date_range, color: Colors.white),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    onTap: () => _selectTime(context),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Time',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.access_time, color: Colors.white),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    items: ['Domestic Abuse', 'Accident', 'Harassment']
                        .map((String crimeType) {
                      return DropdownMenuItem<String>(
                        value: crimeType,
                        child: Text(crimeType, style: TextStyle(fontFamily: 'outfit',color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // Handle crime type selection
                    },
                    decoration: InputDecoration(
                      labelText: 'Crime Type',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.category, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Attachment',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.attach_file, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.attach_file, color: Colors.white),
                        onPressed: () {
                          _selectFile(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontFamily: 'outfit',color: Colors.white),
                      prefixIcon: Icon(Icons.description, color: Colors.white),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: isAnonymous,
                        onChanged: (bool? value) {
                          setState(() {
                            isAnonymous = value ?? false;
                          });
                        },
                      ),
                      Text('Submit Anonymously', style: TextStyle(fontFamily: 'outfit',color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 32.0),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        CrimeRegistrationController.instance.submitCrimeReport();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.white,
                        elevation: 0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFF),
                              Color(0xFFFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: 'outfit',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Icon(
                              Icons.send, // You can use a different icon if needed
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<void> _selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Handle the selected file, you can access it using result.files.first
      print('File picked: ${result.files.first.name}');
    }
  }
}

class ResponsiveAppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: [
        _buildNavBarItem("Home", Icons.home, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserPanel()),
          );
        }),
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Community Forum", Icons.group, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CommunityForumPage()),
            );
          }),
        _buildNavBarItem("Map", Icons.map, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapPage()),
          );
        }),
        _buildNavBarItem("Safety Directory", Icons.book, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SafetyDirectory()),
          );
        }),
        _buildNavBarItem("Crime Registeration", Icons.report, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CrimeRegistrationForm()),
          );
        }),
        _buildNavBarItem("Blogs", Icons.newspaper, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BlogPage()),
          );
        }),
        _buildIconButton(
          icon: Icons.person,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: title,
    ): Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Color(0xFF769DC9)),
          onPressed: onPressed,
          tooltip: title,
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            title,
            style: TextStyle(color: Color(0xFF769DC9)),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ): InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: Color(0xFF769DC9)),
            onPressed: null, // Disable IconButton onPressed
            tooltip: "User Profile",
          ),
          Text(
            "User Profile",
            style: TextStyle(color: Color(0xFF769DC9)),
          ),
        ],
      ),
    );
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
            icon: Icon(Icons.menu, color: Colors.white),
            color: Colors.white,
          ),
      ],
    );
  }
}