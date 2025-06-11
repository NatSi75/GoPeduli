import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Untuk menampilkan gambar dari URL
import '../models/article_model.dart'; // Pastikan ini terimpor
import 'article_screen.dart'; // Untuk menavigasi ke detail artikel

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Article>> _bookmarkedArticlesFuture;

  @override
  void initState() {
    super.initState();
    _bookmarkedArticlesFuture = _fetchBookmarkedArticles();
  }

  Future<List<Article>> _fetchBookmarkedArticles() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Pengguna tidak login, tidak ada artikel yang dibookmark
      return [];
    }

    try {
      // 1. Ambil daftar ID artikel yang dibookmark oleh pengguna
      final bookmarkSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarked_articles')
          .orderBy('bookmarkedAt',
              descending: true) // Urutkan berdasarkan waktu bookmark
          .get();

      if (bookmarkSnapshot.docs.isEmpty) {
        return []; // Tidak ada bookmark
      }

      // Ekstrak articleId dari dokumen bookmark
      final List<String> bookmarkedArticleIds =
          bookmarkSnapshot.docs.map((doc) => doc.id).toList();

      // 2. Ambil detail artikel sebenarnya dari koleksi 'articles'
      // Batasan 'whereIn' adalah 10 item. Jika lebih dari 10, perlu batching.
      // Untuk demo ini, kita asumsikan kurang dari atau sama dengan 10.
      if (bookmarkedArticleIds.isEmpty) {
        return [];
      }

      final List<Article> articles = [];
      // Pecah menjadi batch 10 jika lebih dari 10
      for (int i = 0; i < bookmarkedArticleIds.length; i += 10) {
        final end = (i + 10 < bookmarkedArticleIds.length)
            ? i + 10
            : bookmarkedArticleIds.length;
        final sublistIds = bookmarkedArticleIds.sublist(i, end);

        final articlesSnapshot = await _firestore
            .collection('articles')
            .where(FieldPath.documentId, whereIn: sublistIds)
            .get();

        articles.addAll(articlesSnapshot.docs
            .map((doc) => Article.fromFirestore(doc))
            .toList());
      }

      // Opsional: Urutkan artikel sesuai urutan bookmark asli jika diinginkan.
      // Firebase whereIn tidak menjamin urutan.
      // Map artikel berdasarkan ID untuk pengurutan mudah
      final Map<String, Article> articleMap = {
        for (var article in articles) article.id: article
      };
      final List<Article> sortedArticles = bookmarkedArticleIds
          .where((id) => articleMap.containsKey(id)) // Pastikan artikel ada
          .map((id) => articleMap[id]!)
          .toList();

      return sortedArticles;
    } catch (e) {
      debugPrint('Error fetching bookmarked articles: $e');
      // Anda bisa menampilkan pesan error kepada pengguna
      throw Exception('Failed to load saved articles. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'Saved Articles',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan
        elevation: 0, // Tidak ada bayangan
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Article>>(
        future: _bookmarkedArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _bookmarkedArticlesFuture =
                              _fetchBookmarkedArticles(); // Coba lagi
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No saved articles yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final List<Article> bookmarkedArticles = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: bookmarkedArticles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final article = bookmarkedArticles[index];
              return _buildArticleCard(
                  article); // Gunakan fungsi card baru di sini
            },
          );
        },
      ),
    );
  }

  // Fungsi untuk membangun kartu artikel (mirip dengan di HomeScreen)
  Widget _buildArticleCard(Article article) {
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
        height: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // ignore: deprecated_member_use
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
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700])),
                  const SizedBox(height: 4),
                  Text(article.title,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    // Menggunakan formattedDate dari model
                    '${article.formattedDate} • Verified by ${article.verifiedBy}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      article.body,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/placeholder.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
