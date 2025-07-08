import 'package:flutter/material.dart';
import 'package:dsync_meetup_app/widgets/chat/message_bubble.dart';
import 'package:dsync_meetup_app/widgets/chat/chat_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add this handler function
    void handleSendMessage(String message) {
      // Implement your message sending logic here
      print('Message sent: $message');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (ctx, index) => MessageBubble(
                    text: 'Sample message $index',
                    isMe: index % 2 == 0,
                  ),
            ),
          ),
          ChatInput(
            onSendMessage: handleSendMessage, // Added required parameter
          ),
        ],
      ),
    );
  }
}