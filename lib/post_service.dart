import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;


  static Future<String?> uploadImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null){
      print("no image selected");
      return null;
    }
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference storageRef = referenceRoot.child('images');
    Reference imageToUpload=storageRef.child(fileName);
    await imageToUpload.putFile(File(pickedImage!.path));
    String downloadURL=await imageToUpload.getDownloadURL();


    return downloadURL;
  }

  static Future<void> addNewItem(Map<String, dynamic> newItem) async {
    // Add the new item to the 'items' collection in Firestore
    await _database.collection('items').add(newItem);
  }
}
