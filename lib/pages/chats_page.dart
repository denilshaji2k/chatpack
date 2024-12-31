//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

//Services
import '../services/navigation_service.dart';

//Pages
import '../pages/chat_page.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatsPageState();
  }
}

class ChatsPageState extends State<ChatsPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationService navigation;
  late ChatsPageProvider pageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03,
            vertical: deviceHeight * 0.02,
          ),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    auth.logOut();
                  },
                ),
              ),
              chatsList(),
            ],
          ),
        );
      },
    );
  }

  Widget chatsList() {
    List<Chat>? chats = pageProvider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.length != 0) {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return chatTile(
                  chats[_index],
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No Chats Found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget chatTile(Chat chat) {
    List<ChatUser> recepients = chat.recepientS();
    bool isActive = recepients.any((d) => d.wasRecentlyActive());
    String subtitleText = "";
    if (chat.messages.isNotEmpty) {
      subtitleText = chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: deviceHeight * 0.10,
      title: chat.title(),
      subtitle: subtitleText,
      imagePath: chat.imageURL(),
      isActive: isActive,
      isActivity: chat.activity,
      onTap: () {
        navigation.navigateToPage(
          ChatPage(chat: chat),
        );
      },
    );
  }
}
