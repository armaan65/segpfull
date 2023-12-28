import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:segpnew/screens/chat.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Rash Severity'),
    ChatPage(),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Color(0xFF53CADA),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                  )
                : Text('No image selected.'),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                  } else {
                    print('No image selected.');
                  }
                });
              },
              child: Text('Select Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                  } else {
                    print('No image selected.');
                  }
                });
              },
              child: Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Material(
        color: Color(0xFF53CADA),
        child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Rash Severity',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      ),
    );
  }
}
