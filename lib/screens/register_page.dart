import 'package:flutter/material.dart';
import 'package:segpnew/screens/chat.dart';

class RegisterPage extends StatelessWidget{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xFF53CADA),
      ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          
          TextField(
            obscureText: true,
            controller: confirmpasswordController,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
            ),
          ),
          ElevatedButton(onPressed: () {
            //Obtain values of input fields
            String username = usernameController.text;
            String password = passwordController.text;
            String confirmPassword = confirmpasswordController.text;

            //Checking if password and confirm password are same

            if (password == confirmPassword){
              print("Username: $username, Password: $password");
            }
            else{
              print("Passwords do not match");
            };

            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
          },
          child: Text('Register'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF53CADA),
            foregroundColor: Colors.white
          )
          ),
        ]
      ),
    ),
  );
  }
}