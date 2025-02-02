import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';

import '../models/chat.dart';
import '../models/chat_message.dart';

import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late ChatPageProvider pageProvider;

  late GlobalKey<FormState> messageFormState;
  late ScrollController messagesListViewController;

  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
    messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              this.widget.chat.uid, auth, messagesListViewController),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03,
                vertical: deviceHeight * 0.02,
              ),
              height: deviceHeight,
              width: deviceWidth * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    this.widget.chat.title(),
                    fontSize: 15,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        pageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        pageProvider.goBack();
                      },
                    ),
                  ),
                  messagesListView(),
                  sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget messagesListView() {
    if (pageProvider.messages != null) {
      if (pageProvider.messages!.isNotEmpty) {
        return Container(
          height: deviceHeight * 0.74,
          child: ListView.builder(
            controller: messagesListViewController,
            itemCount: pageProvider.messages!.length,
            itemBuilder: (BuildContext context, int index) {
              ChatMessage message = pageProvider.messages![index];
              bool isOwnMessage = message.senderID == auth.users.uid;
              return Container(
                child: CustomChatListViewTile(
                  deviceHeight: deviceHeight,
                  width: deviceWidth * 0.80,
                  message: message,
                  isOwnMessage: isOwnMessage,
                  sender: this
                      .widget
                      .chat
                      .members
                      .where((m) => m.uid == message.senderID)
                      .first,
                ),
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
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
  }

  Widget sendMessageForm() {
    return Container(
      height: deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.03,
      ),
      child: Form(
        key: messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            messageTextField(),
            sendMessageButton(),
            imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget messageTextField() {
    return SizedBox(
      width: deviceWidth * 0.65,
      child: CustomTextFormField(
          onSaved: (value) {
            pageProvider.message = value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: "Type a message",
          obscureText: false),
    );
  }

  Widget sendMessageButton() {
    double size = deviceHeight * 0.04;
    return Container(
      height: size,
      width: size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (messageFormState.currentState!.validate()) {
            messageFormState.currentState!.save();
            pageProvider.sendTextMessage();
            messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget imageMessageButton() {
    double size = deviceHeight * 0.04;
    return Container(
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        onPressed: () {
          pageProvider.sendImageMessage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
