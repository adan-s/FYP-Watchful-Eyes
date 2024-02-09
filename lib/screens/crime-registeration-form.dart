import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/map.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../authentication/controllers/crime_registeration_controller.dart';
import 'blogs.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

bool attachmentsSelected = false;
bool recordingsSelected = false;

class CrimeRegistrationForm extends StatefulWidget {
  const CrimeRegistrationForm({Key? key}) : super(key: key);

  @override
  _CrimeRegistrationFormState createState() => _CrimeRegistrationFormState();
}

class _CrimeRegistrationFormState extends State<CrimeRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime;
  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    final CrimeRegistrationController controller =
        Get.put(CrimeRegistrationController());

    Future<String> getAddressFromCoordinates(
        double latitude, double longitude) async {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        } else {
          return "Address not found";
        }
      } catch (e) {
        print("Error converting coordinates to address: $e");
        return "Error fetching address";
      }
    }

    Future<void> _getCurrentLocationOnLoad() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        String address = await getAddressFromCoordinates(
            position.latitude, position.longitude);

        setState(() {
          controller.location.value =
              GeoPoint(position.latitude, position.longitude);
          locationController.text =
              '(${position.latitude}, ${position.longitude})\n$address';
          print('location stored');
        });
      } catch (e) {
        print('location fetching failed');
      }
    }

    Future<void> _getCoordinatesFromAddress(String address) async {
      try {
        List<Location> locations = await locationFromAddress(address);

        if (locations.isNotEmpty) {
          Location location = locations.first;
          setState(() {
            controller.location.value =
                GeoPoint(location.latitude, location.longitude);
            locationController.text =
                '(${location.latitude}, ${location.longitude})\n$address';
            print('Location from address stored');
          });
        } else {
          setState(() {
            print('Location not found for the entered address');
            // Handle error if location not found
          });
        }
      } catch (e) {
        print('Error getting coordinates from address: $e');
        setState(() {
          // Handle error
        });
      }
    }

    void resetLocation() {
      setState(() {
        controller.location.value = null;
        locationController.text = '';
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF769DC9), Color(0xFF769DC9)],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
        title: const Text(
          'Crime Registration',
          style: TextStyle(fontFamily: 'outfit', color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          ResponsiveAppBarActions(),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    const Row(
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
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.fullNameController,
                      maxLength: 30,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        counterText: '',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full Name is required';
                        }
                        if (value.length > 30) {
                          return 'Max 30 characters allowed';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Alphabets and Spaces allowed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.phoneNumberController,
                      style: const TextStyle(color: Colors.white),
                      maxLength: 11,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        counterText: '',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required';
                        }
                        if (value.length > 11) {
                          return 'Phone Number should not exceed 11 characters';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone Number can only contain numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: locationController,
                      onTap: _getCurrentLocationOnLoad,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.selectedDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          String formattedMonth =
                              selectedDate.month.toString().padLeft(2, '0');
                          String formattedDay =
                              selectedDate.day.toString().padLeft(2, '0');
                          controller.selectedDateController.text =
                              "$formattedMonth/$formattedDay/${selectedDate.year}";
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of Birth is required';
                        }

                        final RegExp dateRegExp =
                            RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        if (!dateRegExp.hasMatch(value)) {
                          return 'Enter a valid date format (MM/DD/YYYY)';
                        }

                        try {
                          // Parse the selected date using the correct format
                          DateTime selectedDate =
                              DateFormat('MM/dd/yyyy').parseStrict(value);
                        } catch (e) {
                          return 'Enter a valid date';
                        }

                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.date_range, color: Colors.white),
                        suffixIcon:
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.selectedTimeController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                            controller.selectedTimeController.text =
                                selectedTime.toString();
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Time is required';
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon:
                            Icon(Icons.access_time, color: Colors.white),
                        suffixIcon:
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      items: [
                        'Domestic Abuse',
                        'Accident',
                        'Harassment',
                        'Other'
                      ].map((String crimeType) {
                        return DropdownMenuItem<String>(
                          value: crimeType,
                          child: Text(
                            crimeType,
                            style: const TextStyle(
                                fontFamily: 'outfit', color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        controller.crimeType.value = value ?? 'Other';
                      },
                      decoration: const InputDecoration(
                        labelText: 'Crime Type',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.category, color: Colors.white),
                      ),
                      dropdownColor: const Color(0xFF769DC9),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.attach_file,
                                  color: Colors.white),
                              onPressed: () {
                                _uploadCrimeAttachments(context);
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              attachmentsSelected
                                  ? 'Attachments Selected'
                                  : 'Attachments',
                              style: TextStyle(
                                fontFamily: 'outfit',
                                color: attachmentsSelected
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        // Divider(
                        //   color: Color(0xFF747775), // Set the color of the line
                        //   thickness: 1, // Set the thickness of the line
                        // ),
                        Divider(
                          color: attachmentsSelected
                              ? const Color(0xFF747775)
                              : Colors.red,
                          thickness: 1, // Set the thickness of the line
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.mic, color: Colors.white),
                              onPressed: () {
                                _pickVoiceMessage();
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              recordingsSelected
                                  ? 'Recording Selected'
                                  : 'Recording',
                              style: TextStyle(
                                fontFamily: 'outfit',
                                color: recordingsSelected
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: recordingsSelected
                              ? const Color(0xFF747775)
                              : Colors.red,
                          thickness: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.descriptionController,
                      style: const TextStyle(color: Colors.white),
                      maxLength: 150,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                            fontFamily: 'outfit', color: Colors.white),
                        prefixIcon:
                            Icon(Icons.description, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: controller.isAnonymous.value,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  controller.isAnonymous.value = value;
                                }
                              },
                            )),
                        const Text('Submit Anonymously',
                            style: TextStyle(
                                fontFamily: 'outfit', color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            CrimeRegistrationController.instance
                                .submitCrimeReport();
                            resetLocation();
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF),
                                Color(0xFFFF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          child: const Row(
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
                                Icons.send,
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
      ),
    );
  }

  Future<void> _uploadCrimeAttachments(BuildContext context) async {
    try {
      List<XFile>? imageFiles;

      final ImagePicker picker = ImagePicker();
      imageFiles = await picker.pickMultiImage();

      if (imageFiles != null && imageFiles.isNotEmpty) {
        List<String> imageUrls = [];
        Uint8List data;

        for (var imageFile in imageFiles) {
          if (imageFile is XFile) {
            data = await imageFile.readAsBytes();

            String imageName = DateTime.now().millisecondsSinceEpoch.toString();

            final metadata =
                firebase_storage.SettableMetadata(contentType: 'image/*');
            final storageRef = firebase_storage.FirebaseStorage.instance.ref();

            firebase_storage.UploadTask? uploadTask;

            uploadTask = storageRef
                .child("crimeAttachments/$imageName.jpeg")
                .putData(data, metadata);

            // Inside _uploadCrimeAttachments function
            await uploadTask!.whenComplete(() async {
              String imageUrl = await storageRef
                  .child("crimeAttachments/$imageName.jpeg")
                  .getDownloadURL();
              imageUrls.add(imageUrl);
            });
          } else {
            throw Exception("Unsupported image file type");
          }
        }

        // Update attachments string in CrimeRegistrationController
        if (imageUrls.isNotEmpty) {
          setState(() {
            CrimeRegistrationController.instance.attachments.value =
                imageUrls.join(',');
            print("Uploaded image URLs: $imageUrls");
            attachmentsSelected = true;
          });
        } else {
          setState(() {
            print("No attachments selected");
            attachmentsSelected = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        print('Error uploading crime attachments: $e');
        // Handle the error as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                'Failed to upload crime attachments. Please try again.',
              ),
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
      });
    }
  }

  Future<void> _pickVoiceMessage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'ogg'],
      );

      if (result != null && result.files.isNotEmpty) {
        // Handle selected audio file
        File audioFile = File(result.files.first.path!);
        _uploadVoiceMessage(audioFile);
        setState(() {
          recordingsSelected = true;
        });
      }
    } catch (e) {
      print('Error picking voice message: $e');

      // Handle the error as needed
    }
  }

  Future<void> _uploadVoiceMessage(File audioFile) async {
    try {
      Uint8List data = await audioFile.readAsBytes();
      String audioName = DateTime.now().millisecondsSinceEpoch.toString();

      final metadata =
          firebase_storage.SettableMetadata(contentType: 'audio/*');
      final storageRef = firebase_storage.FirebaseStorage.instance.ref();

      firebase_storage.UploadTask? uploadTask;

      uploadTask = storageRef
          .child("voiceMessages/$audioName.mp3")
          .putData(data, metadata);

      await uploadTask!.whenComplete(() async {
        String audioUrl = await storageRef
            .child("voiceMessages/$audioName.mp3")
            .getDownloadURL();

        CrimeRegistrationController.instance.voiceMessageUrl.value = audioUrl;
        print("Uploaded voice message URL: $audioUrl");
      });
    } catch (e) {
      print('Error uploading voice message: $e');
      // Handle the error as needed
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
        if (!kIsWeb)
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
        _buildNavBarItem("Crime Registration", Icons.report, () {
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
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
            tooltip: title,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(icon, color: const Color(0xFF769DC9)),
                onPressed: onPressed,
                tooltip: title,
              ),
              GestureDetector(
                onTap: onPressed,
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF769DC9)),
                ),
              ),
            ],
          );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          )
        : InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(icon, color: const Color(0xFF769DC9)),
                  onPressed: null,
                  tooltip: "User Profile",
                ),
                const Text(
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
    return Row(children: [
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
          icon: const Icon(Icons.menu, color: Colors.white),
          color: Colors.white,
        ),
    ]);
  }
}
