// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';

// import '../services/database_service.dart';
// import '../services/navigation_service.dart';
// import '../models/chat_user.dart';

// class AuthenticationProvider extends ChangeNotifier {
//   late final FirebaseAuth auth;
//   late final DatabaseService databaseService;
//   late final NavigationService navigationService;
//   late ChatUser users;

//   AuthenticationProvider() {
//     auth = FirebaseAuth.instance;
//     databaseService = GetIt.instance<DatabaseService>();
//     navigationService = GetIt.instance<NavigationService>();

//     auth.authStateChanges().listen((User? user) {
//       if (user == null) {
//         log('User is currently signed out!');
//       } else {
//         databaseService.updateUserLastSeenTime(user.uid);
//         databaseService.getUser(user.uid).then((snapshot) {
//           Map<String, dynamic> userData =
//               snapshot.data()! as Map<String, dynamic>;
//           users = ChatUser.fromJson(
//             {
//               "uid": user.uid,
//               "email": userData["email"],
//               "name": userData["name"],
//               "image": userData["imageUrl"],
//               "lastActive": userData["lastActive"],
//             },
//           );
//           print(users.toMap());

//         },
//         );
//       }
//     });
//   }

//   Future<void> loginUsingEmailAndPassword(String email, String password) async {
//     try {
//       await auth.signInWithEmailAndPassword(email: email, password: password);
//       print(auth.currentUser);
//     } on FirebaseAuthException {
//       print("Error logging into firebase");
//     } catch (e) {
//       print(e);
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final DatabaseService databaseService;
  late final NavigationService navigationService;
  late ChatUser users;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    databaseService = GetIt.instance<DatabaseService>();
    navigationService = GetIt.instance<NavigationService>();
    auth.signOut();

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        databaseService.updateUserLastSeenTime(user.uid);
        databaseService.getUser(user.uid).then((snapshot) {
          if (snapshot.data() != null) {
            Map<String, dynamic> userData =
                snapshot.data()! as Map<String, dynamic>;
            users = ChatUser.fromJson(
              {
                "uid": user.uid,
                "email": userData["email"],
                "name": userData["name"],
                "image": userData["imageUrl"],
                "lastActive": userData["lastActive"] != null
                    ? userData["lastActive"].toDate().toIso8601String()
                    : DateTime.now().toIso8601String(), // Convert Timestamp to String
              },
            );
            navigationService.removeAndNavigateToRoute('/home');
          } else {
            navigationService.removeAndNavigateToRoute('/login');
          }
        });
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print(auth.currentUser);
    } on FirebaseAuthException {
      print("Error logging into firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
   return credentials.user!.uid;
    } on FirebaseAuthException {
    print("Error registering user");
    } catch (e) {
      print(e);
    }
    return null;
  }

   Future<bool> logOut() async {
    try {
      await auth.signOut();
      navigationService.removeAndNavigateToRoute('/login');
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Firebase logout error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error during logout: $e');
      return false;
    }
  }
}
