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

  // Helper function to check if the doctor's schedule includes today
  bool isDoctorAvailableToday(String? schedule) {
    if (schedule == null || schedule.isEmpty) {
      return false;
    }

    // Map to convert DateTime weekday (1-7) to Indonesian day name
    const Map<int, String> weekdayMap = {
      1: 'senin',
      2: 'selasa',
      3: 'rabu',
      4: 'kamis',
      5: 'jumat',
      6: 'sabtu',
      7: 'minggu',
    };

    // Get today's day name in lowercase Indonesian
    final String today = weekdayMap[DateTime.now().weekday]!;

    // Normalize the schedule string and check if it contains today's name
    final List<String> scheduledDays =
        schedule.toLowerCase().split(',').map((d) => d.trim()).toList();

    return scheduledDays.contains(today);
  }

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
                hintText: 'Search doctor by name or hospital...',
                prefixIcon: const Icon(Icons.search),
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
              onChanged: (val) =>
                  setState(() => _searchTerm = val.trim().toLowerCase()),
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

                // Filter users based on search term
                var filteredUsers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['Name'] ?? '').toString().toLowerCase();
                  final hospital =
                      (data['Hospital'] ?? '').toString().toLowerCase();
                  return _searchTerm.isEmpty ||
                      name.contains(_searchTerm) ||
                      hospital.contains(_searchTerm);
                }).toList();
                filteredUsers.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;

                  final aIsAvailable =
                      isDoctorAvailableToday(aData['Schedule']);
                  final bIsAvailable =
                      isDoctorAvailableToday(bData['Schedule']);

                  if (aIsAvailable && !bIsAvailable) {
                    return -1; // a (available) comes first
                  } else if (!aIsAvailable && bIsAvailable) {
                    return 1; // b (available) comes first
                  } else {
                    return 0; // order doesn't matter
                  }
                });

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
                    final hospital = data['Hospital'] ?? 'Hospital Unknown';
                    final otherUserId = userDoc.id;
                    final photoUrl = data['ProfilePicture'] ?? '';
                    final schedule = data['Schedule'] as String?;
                    
                    final isAvailableToday = isDoctorAvailableToday(schedule);

                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAvailableToday
                                ? Colors.teal
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage(
                                      'assets/images/default_person.png')
                                  as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Image Load Error: $exception');
                          },
                        ),
                      ),
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hospital),
                          // ✨ UX Improvement: Add a chip to show why they are highlighted
                          if (isAvailableToday)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Chip(
                                label: const Text('Available Today'),
                                labelStyle: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                                backgroundColor: Colors.teal.shade300,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            )
                        ],
                      ),
                      onTap: () async {
                        final chatId =
                            generateChatId(currentUser!.uid, otherUserId);
                        final chatDoc = FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatId);
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
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                receiverUserName: name,
                                receiverUserImage: photoUrl,
                              ),
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