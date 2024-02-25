import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/login_page.dart';

void main() {
  runApp(MyApp());

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthAPI(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF53CADA),
      body: Stack(
        children: [
          Center(
            child: Text(
              "SkinSight",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
              },
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black
              )
            ),
          ),
        ],
      ),
    );
  }
}