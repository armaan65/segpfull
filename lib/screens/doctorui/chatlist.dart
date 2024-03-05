import 'package:flutter/material.dart';
import 'package:segpnew/screens/doctorui/doctorchat.dart';

class ChatListPage extends StatelessWidget {
  final List<String> chatNames = ['Alice', 'Bob', 'Charlie']; // Example chat names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Color(0xFF53CADA), // Darker shade for the AppBar
      ),
      body: ListView.separated(
        itemCount: chatNames.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFFA7E6FF), // Lighter shade for the CircleAvatar
              child: Text(
                chatNames[index][0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chatNames[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Last message preview...'), // Placeholder for last message preview
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatName: chatNames[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement new chat creation functionality
        },
        backgroundColor: Color(0xFF53CADA), // Darker shade for the FloatingActionButton
        child: Icon(Icons.message),
      ),
    );
  }
}
