//Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_user.dart';
import '../models/chat.dart';

//Pages
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseService database;
  late NavigationService navigation;

  List<ChatUser>? users;
  late List<ChatUser> selectedUsers;

  List<ChatUser> get selectedUserS {
    return selectedUsers;
  }

  UsersPageProvider(this.auth) {
    selectedUsers = [];
    database = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    selectedUsers = [];
    try {
      database.getUsers(name: name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["uid"] = doc.id;
              return ChatUser.fromJson(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting users.");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //Create Chat
      List<String> membersIds =
          selectedUsers.map((user) => user.uid).toList();
      membersIds.add(auth.users.uid);
      bool isGroup = selectedUsers.length > 1;
      DocumentReference? doc = await database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": membersIds,
        },
      );
      //Navigate To Chat Page
      List<ChatUser> members = [];
      for (var uid in membersIds) {
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        members.add(
          ChatUser.fromJson(
            userData,
          ),
        );
      }
      ChatPage chatPage = ChatPage(
        chat: Chat(
            uid: doc!.id,
            currentUserUid: auth.users.uid,
            members: members,
            messages: [],
            activity: false,
            group: isGroup),
      );
      selectedUsers = [];
      notifyListeners();
      navigation.navigateToPage(chatPage);
    } catch (e) {
      print("Error creating chat.");
      print(e);
    }
  }
}
