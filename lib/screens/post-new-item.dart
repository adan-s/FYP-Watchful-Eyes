import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostNewItemPage extends StatefulWidget {
  const PostNewItemPage({Key? key}) : super(key: key);

  @override
  _PostNewItemPageState createState() => _PostNewItemPageState();
}

class _PostNewItemPageState extends State<PostNewItemPage> {
  List<XFile> _selectedImages = [];
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(pickedImage);
      });
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
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        iconTheme: IconThemeData(color: Colors.white), // Set back button color
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
                onPressed: () {
                  // Add functionality to post the item
                  // You can access the selected images using _selectedImages
                  // and the description using _descriptionController.text
                },
                child: const Text('Post Item'),
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
        if (_selectedImages.isNotEmpty)
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _selectedImages[index].path as File,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Images'),
        ),
      ],
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
