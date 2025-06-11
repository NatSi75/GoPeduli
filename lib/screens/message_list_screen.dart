import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'doctor_search_screen.dart'; 

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                  // --- PERUBAHAN DI SINI ---
                  // Mendefinisikan border saat tidak fokus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),

                  // Mendefinisikan border saat fokus menjadi TEAL
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('members', arrayContains: currentUser.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }
                  return _buildFilteredChatList(snapshot.data!.docs, currentUser.uid);
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

  Widget _buildFilteredChatList(List<QueryDocumentSnapshot> chats, String currentUserId) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final members = List<String>.from(chat['members']);
        final otherUserId = members.firstWhere((id) => id != currentUserId, orElse: () => '');

        if (otherUserId.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(
                leading: CircleAvatar(),
                title: Text("Loading..."),
              );
            }
            if (!userSnapshot.hasData) {
              return const SizedBox.shrink();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
            final name = userData['Name'] as String? ?? 'No Name';

            if (_searchQuery.isNotEmpty && !name.toLowerCase().contains(_searchQuery.toLowerCase())) {
              return const SizedBox.shrink();
            }

            final photoUrl = userData['profilePicture'] ?? '';
            final lastMessage = chat['lastMessage'] ?? '';
            final lastMessageTimestamp = chat['createdAt'] as Timestamp?;
            final data = chat.data() as Map<String, dynamic>?;
            final lastSeenMap = (data != null && data.containsKey('lastSeenBy'))
                ? Map<String, dynamic>.from(data['lastSeenBy'])
                : {};
            final lastSeenTimestamp = lastSeenMap[currentUserId] as Timestamp?;
            final hasUnread = lastMessageTimestamp != null &&
                (lastSeenTimestamp == null || lastMessageTimestamp.toDate().isAfter(lastSeenTimestamp.toDate()));

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
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/images/default_person.png') as ImageProvider,
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading image: $exception');
                },
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (lastMessageTimestamp != null)
                    Text(
                      TimeOfDay.fromDateTime(lastMessageTimestamp.toDate()).format(context),
                      style: const TextStyle(fontSize: 12),
                    ),
                  const SizedBox(height: 4),
                  if (hasUnread)
                    Container(
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
  }
}