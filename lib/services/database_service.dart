import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService() ;

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).set(
        {
          "email": email,
          "image": imageURL,
          "last_active": DateTime.now().toUtc(),
          "name": name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = db.collection(USER_COLLECTION);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage message) async {
    try {
      await db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String chatID, Map<String, dynamic> data) async {
    try {
      DocumentSnapshot chatDoc = await db.collection(CHAT_COLLECTION).doc(chatID).get();
      if (chatDoc.exists) {
        await db.collection(CHAT_COLLECTION).doc(chatID).update(data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      DocumentSnapshot userDoc = await db.collection(USER_COLLECTION).doc(uid).get();
      if (userDoc.exists) {
        await db.collection(USER_COLLECTION).doc(uid).update(
          {
            "last_active": DateTime.now().toUtc(),
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await db.collection(CHAT_COLLECTION).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      DocumentReference chat =
          await db.collection(CHAT_COLLECTION).add(data);
      return chat;
    } catch (e) {
      print(e);
    }
    return null;
  }
}





























// import 'package:cloud_firestore/cloud_firestore.dart';

// const String USER_COLLECTION = "Users";
// const String CHAT_COLLECTION = "Chats";
// const String MESSAGES_COLLECTION = "Messages";

// class DatabaseService {
//   final FirebaseFirestore db = FirebaseFirestore.instance;

//   Future<void> createUser(
//       String uid, String email, String name, String imageURL) async {
//     try {
//       await db.collection(USER_COLLECTION).doc(uid).set({
//         "email": email,
//         "name": name,
//         "image": imageURL,
//         "lastActive": DateTime.now().toUtc(),
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<DocumentSnapshot> getUser(String uid) async {
//     return await db.collection(USER_COLLECTION).doc(uid).get();
//   }

//   Future<void> updateUserLastSeenTime(String uid) async {
//     try {
//       DocumentSnapshot userDoc = await db.collection(USER_COLLECTION).doc(uid).get();
//       if (userDoc.exists) {
//         await db.collection(USER_COLLECTION).doc(uid).update({
//           "lastActive": DateTime.now().toUtc(),
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
