import 'package:flutter/material.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:segpnew/scortenscoreprovider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = 'John';
  String lastName = 'Davies';
  late Future<void> loadUserFuture;
  String? email;

  @override
  void initState(){
    super.initState();
    final authAPI = context.read<AuthAPI>();
    loadUserFuture = authAPI.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final scortenScoreProvider = Provider.of<ScortenScoreProvider>(context);
    return FutureBuilder(
      future: loadUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final authAPI = context.read<AuthAPI>();
          email = authAPI.email;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Color(0xFF53CADA),
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
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
                email != null
                ? Text(
                  '$email',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )
               : CircularProgressIndicator(),
                SizedBox(height: 20),
                (scortenScoreProvider.scortenScore != null)
                ? Text(
                  'SCORTEN Score: ${scortenScoreProvider.scortenScore}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )
                : CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
