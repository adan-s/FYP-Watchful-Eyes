import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/map.dart';
import 'package:fyp/screens/panicButton.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../authentication/authentication_repo.dart';
import '../authentication/controllers/crime_registeration_controller.dart';
import 'AddContact.dart';
import 'MapPickerScreen.dart';
import 'blogs.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

import 'journeyTrack.dart';
import 'login_screen.dart';
import 'notificationService.dart';

bool attachmentsSelected = false;
bool recordingsSelected = false;

class CrimeRegistrationForm extends StatefulWidget {
  const CrimeRegistrationForm({Key? key}) : super(key: key);

  @override
  _CrimeRegistrationFormState createState() => _CrimeRegistrationFormState();
}
Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

class _CrimeRegistrationFormState extends State<CrimeRegistrationForm> {

  LatLng? _selectedLocation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime;
  bool isAnonymous = false;
  final CrimeRegistrationController controller =
  Get.put(CrimeRegistrationController());


  void registerCrime() {
    NotificationService(userLocation: _selectedLocation).sendNotifications();
    }



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


  Future<void> _pickLocationFromMap(bool fromIcon) async {
    if (fromIcon) {
      final LatLng? pickedLocation = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPickerScreen(initialLocation: _selectedLocation),
        ),
      );

      if (pickedLocation != null) {
        String address = await getAddressFromCoordinates(
          pickedLocation.latitude,
          pickedLocation.longitude,
        );

        setState(() {
          _selectedLocation = pickedLocation;
          controller.location.value = GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude);
          locationController.text =
          '(${pickedLocation.latitude}, ${pickedLocation.longitude})\n$address';
        });
      }
    } else {
      // If the text field is tapped, also open the map screen
      final LatLng? pickedLocation = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPickerScreen(initialLocation: _selectedLocation),
        ),
      );

      if (pickedLocation != null) {
        String address = await getAddressFromCoordinates(
          pickedLocation.latitude,
          pickedLocation.longitude,
        );

        setState(() {
          _selectedLocation = pickedLocation;
          controller.location.value = GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude);
          locationController.text =
          '(${pickedLocation.latitude}, ${pickedLocation.longitude})\n$address';
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {


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
                        labelStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                      ],
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
                      maxLength: 13,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        counterText: '',
                        labelStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),

                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required';
                        }
                        final cleanedPhoneNumber = value.replaceAll(RegExp(r'\D'), '');
                        // if (cleanedPhoneNumber.length == 13) {
                        //   return 'Enter a valid phone number';
                        // }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: locationController,
                      readOnly: true,
                      onTap: () async {
                        await _pickLocationFromMap(false);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
                        prefixIcon: Icon(Icons.location_on, color: Colors.white),
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
                          thickness: 1,
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await generatePDF(context);

                            CrimeRegistrationController.instance.submitCrimeReport();
                            resetLocation();
                            registerCrime();

                          }
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
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                "Submit",
                                style: TextStyle(
                                  fontFamily: 'outfit',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
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
        File audioFile = File(result.files.first.path!);
        _uploadVoiceMessage(audioFile);
        setState(() {
          recordingsSelected = true;
        });
      }
    } catch (e) {
      print('Error picking voice message: $e');

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


  Future<void> generatePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
              padding: pw.EdgeInsets.all(20.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Crime Report',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Divider(thickness: 2),
                  pw.SizedBox(height: 20),
                  _buildText('Full Name:', controller.fullNameController.text),
                  _buildText('Phone Number:', controller.phoneNumberController.text),
                  _buildText('Location:', locationController.text),
                  _buildText('Date:', controller.selectedDateController.text),
                  _buildText('Time:', controller.selectedTimeController.text),
                  _buildText('Crime Type:', controller.crimeType.value),
                  _buildText('Description:', controller.descriptionController.text),

                ],
              ),
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/crime_report.pdf');
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generated successfully. Location: ${file.path}'),
        ),
      );
      print('PDF generated successfully. Location: ${file.path}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PDF Generated'),
            content: Text('Would you like to download the PDF file?'),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red, 
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () {
                    _launchFile(file.path);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      );


    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  pw.Widget _buildText(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
void _launchFile(String filePath) async {
  try {
    OpenFile.open(filePath);
  } catch (e) {
    print('Error opening file: $e');
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
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Emergency Contact", Icons.phone, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  AddContact()),
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
        _buildNavBarItem("Logout", Icons.logout, () async {
          bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("Logging out..."),
                    ],
                  ),
                );
              },
              barrierDismissible: false,
            );

            try {
              await AuthenticationRepository.instance.logout();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } catch (e) {
              print("Logout error: $e");
              Navigator.pop(context);
            }
          }
        }),
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

