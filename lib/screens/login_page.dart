import 'package:flutter/material.dart';
import 'package:segpnew/screens/upload_page.dart';
import 'package:appwrite/appwrite.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xFF53CADA),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
              hintText: 'Username',
            ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
              hintText: 'Password',
            ),
            ),
            ElevatedButton(
              onPressed: () {
                //Obtain values of text fields
                String username = usernameController.text;
                String password = passwordController.text;
                //Just testing the input storage with print for now
                print("Username: $username, Password: $password");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()),
                );
              }, 
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
              ),
          ],
        ),),
        );
  }
}