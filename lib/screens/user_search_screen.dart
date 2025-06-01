import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchTerm = val.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredUsers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final name = (data['Name'] ?? '').toString().toLowerCase();
                  final email = (data['Email'] ?? '').toString().toLowerCase();
                  final isNotCurrentUser = doc.id != currentUser?.uid;

                  return isNotCurrentUser &&
                      (_searchTerm.isEmpty || name.contains(_searchTerm) || email.contains(_searchTerm));
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final userDoc = filteredUsers[index];
                    final data = userDoc.data() as Map<String, dynamic>;

                    final name = data['Name'] ?? 'No Name';
                    final email = data['Email'] ?? 'No Email';
                    final photo = data['ProfilePicture'] ?? '';
                    final otherUserId = userDoc.id;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: photo.isNotEmpty
                            ? NetworkImage(photo)
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                      onTap: () async {
                        final chatId = generateChatId(currentUser!.uid, otherUserId);

                        final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);

                        final chatSnapshot = await chatDoc.get();

                        if (!chatSnapshot.exists) {
                          await chatDoc.set({
                            'members': [currentUser!.uid, otherUserId],
                            'createdAt': FieldValue.serverTimestamp(),
                            'lastMessage': '',
                          });
                        }

                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(chatId: chatId),
                            ),
                          );
                        }
                      }
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String generateChatId(String id1, String id2) {
    final sorted = [id1, id2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
