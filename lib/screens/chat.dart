import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/constants/constants.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  List<Document> _messages = [];
  late Client client;
  late Databases databases;
  late Timer _timer;
  String? currentUserEmail;
  ScrollController _scrollController = ScrollController();  // Added ScrollController

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID);
    databases = Databases(client);

    // Get the current user's email
    final authAPI = context.read<AuthAPI>();
    currentUserEmail = authAPI.email;

    _timer = Timer(Duration(seconds: 0), () {});
    startFetchingMessages();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();  // Dispose ScrollController
    super.dispose();
  }

  void startFetchingMessages() {
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchAndSetMessages();
    });
  }

  void stopFetchingMessages() {
    _timer.cancel();
  }

  Future<void> fetchAndSetMessages() async {
    try {
      final documents = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_ID_MESSAGES,
      );
      setState(() {
        _messages = documents.documents;
      });
      _scrollController.animateTo(  // Scroll to bottom after fetching messages
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> sendMessage(String messageBody) async {
    if (messageBody.trim().isEmpty) {
      print('Message is empty');
      return;
    }

    // Retrieve the current user's email from AuthAPI
    final authAPI = context.read<AuthAPI>();
    final String currentUserEmail = authAPI.email ?? 'unknown';

    try {
      await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_ID_MESSAGES,
        documentId: ID.unique(),
        data: {
          'body': messageBody,
          'user_id': currentUserEmail, // Set the user_id to the current user's email
        },
      );
      await fetchAndSetMessages();
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,  // Added ScrollController to ListView.builder
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final Document message = _messages[index];
                final bool isSentByCurrentUser = message.data['user_id'] == currentUserEmail;

                return Container(
                  alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: isSentByCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.data['body'] ?? 'No text',
                      ),
                      /*Text(
                        message.data['user_id'] ?? 'Unknown sender',
                        style: TextStyle(fontSize: 12.0),
                      ),*/
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final String messageBody = _textController.text;
                    sendMessage(messageBody);
                    _textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
