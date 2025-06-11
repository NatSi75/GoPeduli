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

  // Helper function to format the timestamp
  String _formatTimestamp(BuildContext context, Timestamp timestamp) {
    final now = DateTime.now();
    final messageDate = timestamp.toDate();
    
    // Using today's date but without the time component
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (messageDate.isAfter(today)) {
      // Message is from today, show the time
      return TimeOfDay.fromDateTime(messageDate).format(context);
    } else if (messageDate.isAfter(yesterday)) {
      // Message is from yesterday
      return 'Yesterday';
    } else {
      // Message is older than yesterday, show the date
      return '${messageDate.day}/${messageDate.month}/${messageDate.year}';
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
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
                  // This now handles filtering internally
                  return _buildChatList(snapshot.data!.docs, currentUser.uid);
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

  Widget _buildChatList(List<QueryDocumentSnapshot> chats, String currentUserId) {
    // Filter chats based on search query before building the list
    final filteredChats = chats.where((chat) {
      // We need to fetch user data to filter by name, so we do this inside the FutureBuilder
      // For now, we pass all chats to the ListView.builder
      return true;
    }).toList();

    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        final members = List<String>.from(chat['members']);
        final otherUserId =
            members.firstWhere((id) => id != currentUserId, orElse: () => '');

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
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const SizedBox.shrink();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final name = userData['Name'] as String? ?? 'No Name';

            // Apply search filter here
            if (_searchQuery.isNotEmpty &&
                !name.toLowerCase().contains(_searchQuery.toLowerCase())) {
              return const SizedBox.shrink();
            }

            final photoUrl = userData['ProfilePicture'] ?? '';
            final lastMessage = chat['lastMessage'] ?? '';
            final lastMessageTimestamp = chat['createdAt'] as Timestamp?;

            final chatData = chat.data() as Map<String, dynamic>;
            final lastSeenMap = chatData.containsKey('lastSeenBy')
                ? Map<String, dynamic>.from(chatData['lastSeenBy'])
                : <String, dynamic>{};
                
            final lastSeenTimestamp = lastSeenMap[currentUserId] as Timestamp?;
            final hasUnread = lastMessageTimestamp != null &&
                (lastSeenTimestamp == null ||
                    lastMessageTimestamp.toDate().isAfter(lastSeenTimestamp.toDate()));

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ✅ FIX: Pass all required parameters to ChatScreen
                    builder: (context) => ChatScreen(
                      chatId: chat.id,
                      receiverUserName: name,
                      receiverUserImage: photoUrl,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/images/default_person.png')
                        as ImageProvider,
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading image: $exception');
                },
              ),
              title: Text(
                name,
                style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600),
              ),
              subtitle: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (lastMessageTimestamp != null)
                    Text(
                      _formatTimestamp(context, lastMessageTimestamp), // Use helper
                      style: TextStyle(
                        fontSize: 12,
                        color: hasUnread ? Colors.teal : Colors.grey,
                        fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (hasUnread)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 12), // Placeholder for alignment
                ],
              ),
            );
          },
        );
      },
    );
  }
}