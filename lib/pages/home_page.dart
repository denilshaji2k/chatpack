import 'package:flutter/material.dart';

import '../pages/chats_page.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  int currentPage = 0;
  final List<Widget> pages = <Widget>[
ChatsPage(),
UsersPage() , ];
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: widget.pages[widget.currentPage],
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentPage,
        onTap: (index) {
          setState(() {
            widget.currentPage = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_sharp), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp), label: 'Users'),
        ],
      ),
    );
  }
}
