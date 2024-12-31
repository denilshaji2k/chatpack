import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

import '../providers/authentication_provider.dart';

import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService db;
  late CloudStorageService storage;
  late MediaService media;
  late NavigationService navigation;

  AuthenticationProvider auth;
  ScrollController messagesListViewController;

  String chatId;
  List<ChatMessage>? messages;

  late StreamSubscription messagesStream;
  late StreamSubscription keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;

  String? _message;

  String? get message {
    return _message;
  }

  set message(String? value) {
    _message = value;
    notifyListeners();
  }

  ChatPageProvider(this.chatId, this.auth, this.messagesListViewController) {
    db = GetIt.instance.get<DatabaseService>();
    storage = GetIt.instance.get<CloudStorageService>();
    media = GetIt.instance.get<MediaService>();
    navigation = GetIt.instance.get<NavigationService>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      messagesStream = db.streamMessagesForChat(chatId).listen(
        (snapshot) {
          List<ChatMessage> NewMessages = snapshot.docs.map(
            (m) {
              Map<String, dynamic> messageData =
                  m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(messageData);
            },
          ).toList();
          // Fix: Properly assign to messages property
          messages = NewMessages; // This was missing proper assignment
          notifyListeners();
          
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (messagesListViewController.hasClients) {
                messagesListViewController.jumpTo(
                    messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    keyboardVisibilityStream = keyboardVisibilityController.onChange.listen(
      (event) {
        db.updateChatData(chatId, {"is_activity": event});
      },
    );
  }

  void sendTextMessage() {
    if (message != null) {
      ChatMessage messageToSend = ChatMessage(
        content: message!,
        type: MessageType.TEXT,
        senderID: auth.users.uid,
        sentTime: DateTime.now(),
      );
      db.addMessageToChat(chatId, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await storage.saveChatImageToStorage(
            chatId, auth.users.uid, file);
        ChatMessage messageToSend = ChatMessage(
          content: downloadURL!,
          type: MessageType.IMAGE,
          senderID: auth.users.uid,
          sentTime: DateTime.now(),
        );
        db.addMessageToChat(chatId, messageToSend);
      }
    } catch (e) {
      print("Error sending image message.");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    db.deleteChat(chatId);
  }

  void goBack() {
    navigation.goBack();
  }
}
