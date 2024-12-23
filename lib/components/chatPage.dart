import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handi_net_app/components/chat_buble.dart';
import 'package:handi_net_app/models/messageModel.dart';

class ChatPage extends StatefulWidget {
   const ChatPage({super.key, required this.email});

  final String email;
  static String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();

  final TextEditingController _textController = TextEditingController();

  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messagesCollection
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading messages. Please try again later.'),
            );
          }

          if (snapshot.hasData) {
            final messagesList = snapshot.data!.docs
                .map((doc) => Message.fromJson(doc))
                .toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final message = messagesList[index];
                      return message.id == widget.email
                          ? ChatBuble(message: message)
                          : ChatBubleForFriend(message: message);
                    },
                  ),
                ),
                _buildMessageInput(widget.email),
              ],
            );
          } else {
            return const Center(
              child: Text('No messages to display.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildMessageInput(String email) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Send Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.teal),
            onPressed: () => _sendMessage(email),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String email) {
    final messageText = _textController.text.trim();

    if (messageText.isEmpty) return;

    _messagesCollection.add({
      'message': messageText,
      'createdAt': DateTime.now(),
      'id': email,
    });

    _textController.clear();
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
