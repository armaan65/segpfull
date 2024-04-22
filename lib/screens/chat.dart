import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/constants/constants.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  ChatPage({Key? key, required this.chatName}) : super(key: key);

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
    super.dispose();
  }

  void startFetchingMessages() {
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
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
      appBar: AppBar(
        title: Text(widget.chatName),
        backgroundColor: const Color(0xFF53CADA), // Darker shade for the AppBar
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: const BoxDecoration(color: Color(0xFFA7E6FF)), // Lighter shade for the input area
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Document message) {
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
          Text(
            message.data['user_id'] ?? 'Unknown sender',
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: sendMessage,
                decoration: const InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
