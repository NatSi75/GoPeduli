import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'article_screen.dart';
import '../models/article_model.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool isLoading = true;
  bool hasError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> continueReading = [
    {
      'title': 'Benefits of a Checkup',
      'time': '2 min left',
      'imageUrl': 'assets/images/CR1.jpeg',
    },
    {
      'title': 'Most Trusted Pharmacy',
      'time': '4 min left',
      'imageUrl': 'assets/images/CR2.jpg',
    },
    {
      'title': 'Importance of Exercising',
      'time': '5 min left',
      'imageUrl': 'assets/images/CR3.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Fetch user data when HomeScreen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserData();
    });
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .orderBy('CreatedAt', descending: true)
          .get();

      setState(() {
        articles =
            snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading articles: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // ✅ Tambahkan pengecekan ini agar tunggu data user selesai di-fetch
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    debugPrint(
        'HomeScreen build: userName=${userProvider.userName}, profilePicture=${userProvider.profilePicture}');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 20),
              _buildContinueReadingSection(),
              const SizedBox(height: 20),
              _buildLatestArticlesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        String defaultImage;
        switch (userProvider.gender.toLowerCase().trim()) {
          case 'female':
            defaultImage = 'assets/images/default_female.png';
            break;
          case 'male':
            defaultImage = 'assets/images/default_male.png';
            break;
          default:
            defaultImage = 'assets/images/default_person.png';
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(defaultImage),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello,",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.grey[700])),
                Text(userProvider.userName,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildContinueReadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Continue Reading",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: continueReading.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = continueReading[index];
              return _readingCard(
                  item['title'], item['time'], item['imageUrl']);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestArticlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Latest Articles",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildArticleList(),
      ],
    );
  }

  Widget _buildArticleList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load articles'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchArticles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (articles.isEmpty) {
      return const Center(
        child: Text(
          'No articles found',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _articleCard(article);
      },
    );
  }

  Widget _readingCard(String title, String time, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ArticleScreen(articleId: 'dummy_id'),
          ),
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl,
                  width: 140, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(time,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _articleCard(Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleScreen(articleId: article.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.author,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Text(article.title,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '${article.formattedDate} • Verified by ${article.verifiedBy}',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(article.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                  ]),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/placeholder.png',
                          width: 80,
                          height: 80),
                    )
                  : Image.asset('assets/images/placeholder.png',
                      width: 80, height: 80),
            ),
          ],
        ),
      ),
    );
  }
}
