import 'package:flutter/material.dart';
import 'screens/upload_page.dart';
import 'screens/chat.dart';
import 'screens/profile_page.dart'; // Make sure to create this file for ProfilePage

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;


  static List<Widget> _widgetOptions = <Widget>[
    ChatPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), // Icon for Profile
            label: 'Profile', // Label for Profile
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[800],
        onTap: _onItemTapped,
      ),
    );
  }
}