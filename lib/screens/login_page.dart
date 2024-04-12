// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/doctorui/chatlist.dart';
import 'package:segpnew/screens/register_page.dart';
import 'package:segpnew/screens/scorten.dart';
import 'package:appwrite/appwrite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading = false;
  bool _passwordVisible = false;

  void signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
              Text('Signing In...', style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.pop(context);

      // Check if the email and password are equal to doctor's details
      if (emailTextController.text == 'ak123@gmail.com' &&
          passwordTextController.text == 'uninott123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatListPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScortenCalculatorPage()),
        );
      }
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  void showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void signInWithProvider(String provider) {
    try {
      context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7E6FF), // Light blue background
      appBar: AppBar(
        title: const Text('Rash App', style: TextStyle(color: Colors.black)), // Black text for AppBar title
        backgroundColor: Color(0xFF53CADA), // Darker blue for the AppBar
        iconTheme: IconThemeData(color: Colors.black), // Black icons for AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              TextField(
                controller: emailTextController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black), // Black text for labels
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.black), // Black border when enabled
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.black), // Black email icon
                  fillColor: Colors.white,
                  filled: true, // White fill color for contrast
                ),
                style: TextStyle(color: Colors.black), // Black text for input
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordTextController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black), // Black text for labels
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.black), // Black border when enabled
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.black), // Black lock icon
                  fillColor: Colors.white,
                  filled: true, // White fill color for contrast
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black, // Black visibility icon
                    ),
                    onPressed: () {
                      setState(() {
                        // Toggle password visibility
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black), // Black text for input
                obscureText: !_passwordVisible,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  signIn();
                },
                icon: const Icon(Icons.login, color: Colors.white), // White login icon for contrast
                label: const Text("Sign in", style: TextStyle(color: Colors.white)), // White text for button
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF53CADA), // Dark blue button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text('Create Account', style: TextStyle(color: Colors.white,)), // Dark blue text for link
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
