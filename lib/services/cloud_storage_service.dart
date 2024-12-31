// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';

// const String USER_COLLECTION = "Users";

// class CloudStorageService {
//   final FirebaseStorage storage = FirebaseStorage.instance;
  
//    Future<String?> saveUserImageToStorage(
//         String uid, PlatformFile file) async {
//       try {
//         Reference ref =
//             storage.ref().child('images/users/$uid/profile.${file.extension}');
//         UploadTask task = ref.putFile(File(file.path!));
//         await task.then((result) => result.ref.getDownloadURL());
//       } catch (e) {
//         print(e);
//       }
//     }

//   Future<String?> saveChatImageToStorage(
//       String chatID, String userID, PlatformFile file) async {
//     try {
//       Reference ref = storage.ref().child('images/chats/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
//             UploadTask task = ref.putFile(File(file.path!));
//         await task.then((result) => result.ref.getDownloadURL());

//     } catch (e) {
//       print(e);
//     }
//   }
// }


import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Method to save user image to storage
  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref = storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Method to save chat image to storage
  Future<String?> saveChatImageToStorage(String chatID, String userID, PlatformFile file) async {
    try {
      Reference ref = storage.ref().child(
          'images/chats/$chatID/${userID}_${DateTime.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
