import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).set({
        "email": email,
        "name": name,
        "image": imageURL,
        "lastActive": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).update({
        "lastActive": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }
}
