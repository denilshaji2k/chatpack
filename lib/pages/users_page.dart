import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

import '../models/chat_user.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late UsersPageProvider pageProvider;

  final TextEditingController searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    auth.logOut();
                  },
                ),
              ),
              CustomTextField(
                onEditingComplete: (value) {
                  pageProvider.getUsers(name: value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: searchFieldTextEditingController,
                icon: Icons.search,
              ),
              usersList(),
              createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget usersList() {
    List<ChatUser>? users = pageProvider.users;
    return Expanded(child: () {
      if (users != null) {
        if (users.length != 0) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomListViewTile(
                height: deviceHeight * 0.10,
                title: users[index].name,
                subtitle: "Last Active: ${users[index].lastDayActive()}",
                imagePath: users[index].image,
                isActive: users[index].wasRecentlyActive(),
                isSelected: pageProvider.selectedUsers.contains(
                  users[index],
                ),
                onTap: () {
                  pageProvider.updateSelectedUsers(
                    users[index],
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget createChatButton() {
    return Visibility(
      visible: pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: pageProvider.selectedUsers.length == 1
            ? "Chat With ${pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: deviceHeight * 0.08,
        width: deviceWidth * 0.80,
        onPressed: () {
          pageProvider.createChat();
        },
      ),
    );
  }
}



















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get_it/get_it.dart';

// class UsersPage extends StatefulWidget {
//   const UsersPage({super.key});

//   @override
//   State<UsersPage> createState() => _UsersPageState();
// }

// class _UsersPageState extends State<UsersPage> {
//   @override
//   Widget build(BuildContext context) {
//     return buildUI();
//   }

//   Widget buildUI() {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//     );
//   }
// }