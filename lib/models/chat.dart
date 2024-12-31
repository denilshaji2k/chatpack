import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> recepients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    recepients = members.where((i) => i.uid != currentUserUid).toList();
  }

  List<ChatUser> recepientS() {
    return recepients;
  }

  String title() {
    return !group
        ? recepients.isEmpty ? "No name":  recepients.first.getDisplayName()
        : recepients.map((user) => user.getDisplayName()).join(", ");
  }

  String imageURL() {
    return !group
        ? recepients.first.image
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }
}