import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/create_profile.dart';
import 'package:appwrite/appwrite.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading = false;
  bool _passwordVisible = false; // Add this line for password visibility toggle

  // Function to create a new account
  createAccount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createUser(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // Log in the user after account creation
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile())); // Navigate to CreateProfile screen
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Account creation failed', text: e.message.toString());
    }
  }

  // Show an alert dialog
  showAlert({required String title, required String text}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7E6FF), // Light blue background
      appBar: AppBar(
        title: const Text('Create your account', style: TextStyle(color: Colors.black)), // Black text for AppBar title
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
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black), // Black text for input
                obscureText: !_passwordVisible, // Toggle password visibility
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  createAccount();
                },
                icon: const Icon(Icons.app_registration, color: Colors.white), // White icon for contrast
                label: const Text("Sign up", style: TextStyle(color: Colors.white)), // White text for button
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF53CADA), // Dark blue button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
