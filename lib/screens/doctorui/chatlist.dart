import 'package:flutter/material.dart';
import 'package:segpnew/screens/doctorui/doctorchat.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<String> chatNames = ['Alice', 'Bob', 'Charlie']; // Example chat names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: const Color(0xFF53CADA), // Darker shade for the AppBar
      ),
      body: ListView.separated(
        itemCount: chatNames.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFA7E6FF), // Lighter shade for the CircleAvatar
              child: Text(
                chatNames[index][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chatNames[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Last message preview...'), // Placeholder for last message preview
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
    );
  }
}
