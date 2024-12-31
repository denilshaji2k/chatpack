import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseService db;

  List<Chat>? chats;

  late StreamSubscription chatsStream;

  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
  if (auth.users?.uid == null) {
    print("User not authenticated");
    return;
  }

  try {
    chatsStream = db.getChatsForUser(auth.users.uid).listen(
      (snapshot) async {
        try {
          List<Chat> chatsList = [];
          
          for (var doc in snapshot.docs) {
            try {
              Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;
              
              // Validate members exist
              if (!chatData.containsKey("members")) {
                print("Chat ${doc.id} has no members");
                continue;
              }

              // Get Users In Chat
              List<ChatUser> members = [];
              for (var uid in chatData["members"]) {
                try {
                  DocumentSnapshot userSnapshot = await db.getUser(uid);
                  if (userSnapshot.exists) {
                    Map<String, dynamic> userData = 
                        userSnapshot.data() as Map<String, dynamic>;
                    userData["uid"] = userSnapshot.id;
                    members.add(ChatUser.fromJson(userData));
                  }
                } catch (userError) {
                  print("Error fetching user $uid: $userError");
                }
              }

              // Get Last Message
              List<ChatMessage> messages = [];
              try {
                QuerySnapshot chatMessage = 
                    await db.getLastMessageForChat(doc.id);
                if (chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> messageData = 
                      chatMessage.docs.first.data() as Map<String, dynamic>;
                  messages.add(ChatMessage.fromJSON(messageData));
                }
              } catch (messageError) {
                print("Error fetching messages for chat ${doc.id}: $messageError");
              }

              // Create chat instance
              chatsList.add(Chat(
                uid: doc.id,
                currentUserUid: auth.users.uid,
                members: members,
                messages: messages,
                activity: chatData["is_activity"] ?? false,
                group: chatData["is_group"] ?? false,
              ));
            } catch (chatError) {
              print("Error processing chat ${doc.id}: $chatError");
            }
          }

          chats = chatsList;
          notifyListeners();
        } catch (processError) {
          print("Error processing chats: $processError");
        }
      },
      onError: (error) {
        print("Stream error: $error");
      },
      cancelOnError: false,
    );
  } catch (e) {
    print("Fatal error in getChats: $e");
  }
}
}
























//   void getChats() async {
//     try {
//       chatsStream =
//           db.getChatsForUser(auth.users.uid).listen((snapshot) async {
//         chats = await Future.wait(
//           snapshot.docs.map(
//             (d) async {
//               Map<String, dynamic> chatData =
//                   d.data() as Map<String, dynamic>;
//               //Get Users In Chat
//               List<ChatUser> members = [];
//               for (var uid in chatData["members"]) {
//                 DocumentSnapshot userSnapshot = await db.getUser(uid);
//                 Map<String, dynamic> userData =
//                     userSnapshot.data() as Map<String, dynamic>;
//                 userData["uid"] = userSnapshot.id;
//                 members.add(
//                   ChatUser.fromJson(userData),
//                 );
//               }
//               //Get Last Message For Chat
//               List<ChatMessage> messages = [];
//               QuerySnapshot chatMessage =
//                   await db.getLastMessageForChat(d.id);
//               if (chatMessage.docs.isNotEmpty) {
//                 Map<String, dynamic> messageData =
//                     chatMessage.docs.first.data()! as Map<String, dynamic>;
//                 ChatMessage message = ChatMessage.fromJSON(messageData);
//                 messages.add(message);
//               }
//               //Return Chat Instance
//               return Chat(
//                 uid: d.id,
//                 currentUserUid: auth.users.uid,
//                 members: members,
//                 messages: messages,
//                 activity: chatData["is_activity"],
//                 group: chatData["is_group"],
//               );
//             },
//           ).toList(),
//         );
//         notifyListeners();
//       });
//     } catch (e) {
//       print("Error getting chats.");
//       print(e);
//     }
//   }
// }
