// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Timestamp if using Firestore

// class ChatUser {
//   final String uid;
//   final String name;
//   final String email;
//   final String imageUrl;
//   late DateTime lastActive;

//   ChatUser({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.imageUrl,
//     required this.lastActive,
//   });

//   factory ChatUser.fromJson(Map<String, dynamic> json) {
//     return ChatUser(
//       uid: json['uid'] ?? '', // Default to an empty string if null
//       name: json['name'] ?? 'Unknown',
//       email: json['email'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       lastActive: json['lastActive'] is Timestamp
//           ? (json['lastActive'] as Timestamp).toDate() // Convert Timestamp to DateTime
//           : DateTime.parse(json['lastActive'] ?? DateTime.now().toIso8601String()), // Fallback to now
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'imageUrl': imageUrl,
//       'lastActive': lastActive.toIso8601String(),
//     };
//   }

//   String lastDayActive() {
//     return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
//   }

//   bool wasRecentlyActive() {
//     return DateTime.now().difference(lastActive).inMinutes < 5;
//   }
// }

class ChatUser {
  final String uid;
  final String email;
  final String name;
  final String image;
  final String lastActive; // Changed to String

  ChatUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.image,
    required this.lastActive, // Updated to String
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
      'lastActive': lastActive, // Directly convert the DateTime to string
    };
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      lastActive: json['lastActive'], // Assuming lastActive is already a String
    );
  }
}
