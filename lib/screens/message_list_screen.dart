import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'user_search_screen.dart';

class MessageListScreen extends StatelessWidget {
  const MessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("Please log in")));
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Message',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _TabButton(label: 'All', selected: true),
                  SizedBox(width: 10),
                  _TabButton(label: 'Group'),
                  SizedBox(width: 10),
                  _TabButton(label: 'Private'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('members', arrayContains: currentUser.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final chats = snapshot.data!.docs;

                  if (chats.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final members = List<String>.from(chat['members']);
                      final otherUserId = members.firstWhere((id) => id != currentUser.uid, orElse: () => '');

                      final lastMessage = chat['lastMessage'] ?? '';
                      final lastMessageTimestamp = chat['createdAt'] as Timestamp?;
                    final data = chat.data() as Map<String, dynamic>?;

                    final lastSeenMap = (data != null && data.containsKey('lastSeenBy'))
                        ? Map<String, dynamic>.from(data['lastSeenBy'])
                        : {};
                      final lastSeenTimestamp = lastSeenMap[currentUser.uid] as Timestamp?;

                      // Determine if there are unread messages for this user
                      final hasUnread = lastMessageTimestamp != null &&
                          (lastSeenTimestamp == null || lastMessageTimestamp.toDate().isAfter(lastSeenTimestamp.toDate()));

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return const SizedBox.shrink();

                          final userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                          final name = userData['Name'] ?? 'No Name';
                          final photo = userData['ProfilePicture'] ?? '';

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(chatId: chat.id),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: photo.isNotEmpty
                                  ? NetworkImage(photo)
                                  : const AssetImage('assets/image/default_avatar.png') as ImageProvider,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (lastMessageTimestamp != null)
                                  Text(
                                    TimeOfDay.fromDateTime(lastMessageTimestamp.toDate()).format(context),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                if (hasUnread)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '1',
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserSearchScreen()),
            );
          },
          child: const Icon(Icons.chat, color: Colors.white),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabButton({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: selected ? Colors.teal[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.teal[800] : Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
