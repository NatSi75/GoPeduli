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
      appBar: AppBar(title: const Text('Search Doctors')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search doctor by name or email...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
              onChanged: (val) => setState(() => _searchTerm = val.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('Role', isEqualTo: 'doctor')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No doctors available.'));
                }

                final filteredUsers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['Name'] ?? '').toString().toLowerCase();
                  final email = (data['Email'] ?? '').toString().toLowerCase();
                  return _searchTerm.isEmpty ||
                      name.contains(_searchTerm) ||
                      email.contains(_searchTerm);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(child: Text('No doctors found.'));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final userDoc = filteredUsers[index];
                    if (userDoc.id == currentUser?.uid) {
                      return const SizedBox.shrink();
                    }

                    final data = userDoc.data() as Map<String, dynamic>;
                    final name = data['Name'] ?? 'No Name';
                    final email = data['Email'] ?? 'No Email';
                    final otherUserId = userDoc.id;
                    final photoUrl = data['profilePicture'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/images/default_person.png') as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                           print('Image Load Error: $exception');
                        },
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
                      },
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