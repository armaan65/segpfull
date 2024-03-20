import 'dart:async'; 

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/constants/constants.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  List<Document> _messages = [];
  late Client client;
  late Databases databases;
  late Timer _timer; // Declare the Timer variable

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID);
    databases = Databases(client);

    // Initialize the Timer with a dummy Timer object
    _timer = Timer(Duration(seconds: 0), () {});

    // Start fetching messages periodically
    startFetchingMessages();
  }

  @override
  void dispose() {
    super.dispose();

    // Stop fetching messages when the widget is disposed
    stopFetchingMessages();
  }

  // Function to start fetching messages periodically
  void startFetchingMessages() {
    // Cancel any existing timer to avoid multiple simultaneous timers
    _timer.cancel();

    // Start a new timer that fetches messages every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchAndSetMessages(); // Fetch messages every 5 seconds
    });
  }

  // Function to stop fetching messages
  void stopFetchingMessages() {
    _timer.cancel(); // Cancel the timer
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
    } catch (error) {
      print(error);
    }
  }

  Future<void> sendMessage(String messageBody) async {
    try {
      // Create a new document with the message body
      await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_ID_MESSAGES,
        documentId: ID.unique(),
        data: {'body': messageBody, 'user_id': ID.unique()}, // Include the message body in the document data
      );

      // Fetch and update the list of messages after sending the message
      await fetchAndSetMessages();
    } catch (error) {
      print('Error sending message: $error');
      // Handle any errors that occur during message sending
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final Document message = _messages[index];
                return ListTile(
                  title: Text(message.data['body'] ?? 'No text'),
                  subtitle: Text(message.data['user_id'] ?? 'Unknown sender'),
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