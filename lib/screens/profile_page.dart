import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = 'John';
  String lastName = 'Davies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF53CADA),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        color: Color(0xFFA7E6FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 100.0,
              color: Color(0xFF53CADA),
            ),
            SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
