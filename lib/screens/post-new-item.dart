import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostNewItemPage extends StatefulWidget {
  const PostNewItemPage({Key? key}) : super(key: key);

  @override
  _PostNewItemPageState createState() => _PostNewItemPageState();
}

class _PostNewItemPageState extends State<PostNewItemPage> {
  PickedFile? _selectedImage;
  TextEditingController _descriptionController = TextEditingController();
  String checkImageUrl='';

  Future<String?> _uploadImage(PickedFile image) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('image/');
    Reference referenceImageaToUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageaToUpload.putFile(File(image.path));
      checkImageUrl=await referenceImageaToUpload.getDownloadURL();
      print('${checkImageUrl}');
      return checkImageUrl;
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }

  String imageUrl = '';


  Future<void> _postNewItem() async {
    String description = _descriptionController.text;

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    Map<String, dynamic> newItem = {
      'description': description,
    };

    if (imageUrl != null) {
      newItem['imageUrl'] = imageUrl;
    }

    try {
      // Add the new item to the 'items' collection in Firestore
      await FirebaseFirestore.instance.collection('items').add(newItem);

      _descriptionController.clear();
    } catch (e) {
      print("Error posting a new item: $e");
      // Handle the error as needed
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post a New Item',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildDescriptionInput(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _postNewItem,
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildImageWidget(_selectedImage!.path),
          ),
        ElevatedButton(
          onPressed: () async {
            XFile? imageFile;

              final ImagePicker _picker = ImagePicker();
              String fileName = DateTime.now().microsecondsSinceEpoch.toString();
              imageFile = await _picker.pickImage(source: ImageSource.gallery);
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDireImages = referenceRoot.child('image/');
              Reference referenceImageaToUpload = referenceDireImages.child(fileName);
              try{
                SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
                await referenceImageaToUpload.putFile(File(imageFile!.path), metadata);
                checkImageUrl =await referenceImageaToUpload.getDownloadURL();
                print('${checkImageUrl}');
                print('check hy');
              }catch(error)
              {

              }

            if (imageFile != null) {
              setState(() {
                _selectedImage = imageFile as PickedFile?;
              });
            }
          },
          child: const Text('Pick Image'),
        ),
      ],
    );
  }


  Widget _buildImageWidget(String path) {
      // For other platforms, use Image.file
      return Image.file(
        File(path),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      );
  }



  Widget _buildDescriptionInput() {
    return TextField(
      controller: _descriptionController,
      maxLines: 4,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}