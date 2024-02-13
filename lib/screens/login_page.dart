import 'package:flutter/material.dart';
import 'package:segpnew/basePage.dart';
import 'package:segpnew/screens/upload_page.dart';
import 'package:appwrite/appwrite.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading = false;

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color.fromARGB(241, 0, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(),
                ]),
          );
        });

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadPage()));
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

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
                  child: const Text('Ok'))
            ],
          );
        });
  }

  signInWithProvider(String provider) {
    try {
      context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

	  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rash App'),
      ),
      body: Center(
<<<<<<< HEAD
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
                  MaterialPageRoute(builder: (context) => BasePage()),
                );
              }, 
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
=======
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
>>>>>>> Rahim
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordTextController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  signIn();
                },
                icon: const Icon(Icons.login),
                label: const Text("Sign in"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}