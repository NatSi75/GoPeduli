import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || user == null) return;

    final now = Timestamp.now();

    final messageData = {
      'text': text,
      'senderId': user!.uid,
      'senderName': user!.email,
      'timestamp': now,
      'seenBy': [user!.uid], // sender immediately sees their own message
    };

    final chatDoc = FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    await chatDoc.collection('messages').add(messageData);

    await chatDoc.set({
      'lastMessage': text,
      'createdAt': now,
      'members': FieldValue.arrayUnion([user!.uid]),
    }, SetOptions(merge: true));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                // ✅ Update lastSeenBy in chat document
                if (messages.isNotEmpty) {
                  final lastMessage = messages.last;
                  final lastTimestamp = lastMessage['timestamp'];

                  if (lastTimestamp != null && lastTimestamp is Timestamp) {
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatId)
                        .set({
                      'lastSeenBy': {user!.uid: lastTimestamp}
                    }, SetOptions(merge: true));
                  }
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == user?.uid;

                    // Read timestamp
                    final timestamp = msg['timestamp'];
                    String timeString = '';
                    if (timestamp != null && timestamp is Timestamp) {
                      final date = timestamp.toDate();
                      timeString =
                          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    }

                    // safely get seenBy list
                    final seenBy = (msg.data() as Map<String, dynamic>).containsKey('seenBy')
                        ? List<String>.from(msg['seenBy'])
                        : [];

                    // if not yet seen by me — mark it as seen
                    if (!seenBy.contains(user!.uid)) {
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.chatId)
                          .collection('messages')
                          .doc(msg.id)
                          .update({'seenBy': FieldValue.arrayUnion([user!.uid])});
                    }

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        constraints:
                            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.teal[300] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    msg['text'] ?? '',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  timeString,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            if (isMe)
                              Icon(
                                seenBy.length > 1
                                    ? Icons.done_all // double checkmark
                                    : Icons.done, // single checkmark
                                size: 16,
                                color: seenBy.length > 1 ? Colors.white : Colors.white70,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white, // ✅ white text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
