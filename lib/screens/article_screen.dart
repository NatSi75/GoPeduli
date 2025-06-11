import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Penting untuk mendapatkan ID pengguna

class ArticleScreen extends StatefulWidget {
  final String articleId;

  const ArticleScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late Future<Article> _articleFuture;
  bool isBookmarked = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _articleFuture = _fetchArticleDataAndHandleViews();
  }

  // Fungsi baru untuk fetch artikel, handle views, dan cek bookmark
  Future<Article> _fetchArticleDataAndHandleViews() async {
    final articleRef = _firestore.collection('articles').doc(widget.articleId);
    final user = _auth.currentUser; // Dapatkan pengguna saat ini

    // 1. Handle Views
    if (user != null) {
      // Jika pengguna login, cek apakah sudah melihat artikel ini
      final userViewedArticleRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection(
              'viewed_articles') // Sub-koleksi baru untuk melacak artikel yang sudah dilihat
          .doc(widget.articleId);

      final viewedDoc = await userViewedArticleRef.get();

      if (!viewedDoc.exists) {
        // Jika belum ada catatan, ini adalah view pertama dari pengguna ini
        try {
          // Increment 'Views' field di dokumen artikel utama
          await articleRef.update({
            'Views': FieldValue.increment(1),
          });
          // Buat dokumen di sub-koleksi user untuk menandai artikel sudah dilihat
          await userViewedArticleRef.set({
            'viewedAt': FieldValue.serverTimestamp(), // Timestamp kapan dilihat
          });
          debugPrint(
              'Views incremented for ${widget.articleId} by ${user.uid}');
        } catch (e) {
          debugPrint('Error incrementing views or marking as viewed: $e');
          // Lanjutkan proses meskipun ada error di sini
        }
      } else {
        debugPrint(
            'Article ${widget.articleId} already viewed by ${user.uid}. No increment.');
      }
    } else {
      // Optional: Jika pengguna tidak login, Anda bisa memilih untuk tetap meng-increment views
      // atau tidak menghitung views sama sekali.
      // Saat ini, kita tidak akan meng-increment views jika user tidak login untuk fokus pada 'per user'.
      debugPrint('User not logged in. Views not incremented per user.');
    }

    // 2. Cek status bookmark dari pengguna saat ini
    if (user != null) {
      final userBookmarksRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarked_articles')
          .doc(widget.articleId);

      final bookmarkDoc = await userBookmarksRef.get();
      setState(() {
        isBookmarked = bookmarkDoc.exists;
      });
    }

    // 3. Fetch artikel setelah semua operasi di atas
    final docSnapshot = await articleRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Article not found');
    }

    return Article.fromFirestore(docSnapshot);
  }

  void _toggleBookmark() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to bookmark articles.')),
      );
      return;
    }

    final userBookmarkDocRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarked_articles')
        .doc(widget.articleId);

    setState(() {
      isBookmarked = !isBookmarked; // Update UI segera
    });

    try {
      if (isBookmarked) {
        await userBookmarkDocRef.set({
          'bookmarkedAt': FieldValue.serverTimestamp(),
          'articleId': widget.articleId,
          // Anda bisa menyimpan data artikel penting lainnya di sini jika diperlukan
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article bookmarked!')),
        );
      } else {
        await userBookmarkDocRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article unbookmarked.')),
        );
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      setState(() {
        isBookmarked = !isBookmarked; // Rollback UI jika ada error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update bookmark: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: _toggleBookmark,
          ),
        ],
        title: const Text(
          'Article Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _articleFuture =
                            _fetchArticleDataAndHandleViews(); // Retry
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Article not found.'));
          }

          final article = snapshot.data!;
          final formattedDate = article.formattedDate;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl.isNotEmpty)
                  _buildArticleImage(article.imageUrl),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildAuthorRow(
                          article.author, formattedDate, article.views),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Verified by ${article.verifiedBy}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[800],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        article.body,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                      _buildArticleFooter(article.updatedAt),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Container(
            height: 250,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          );
        },
        placeholder: (context, url) {
          return SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthorRow(String author, String date, int views) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage('assets/images/default_person.png'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By $author',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '$date • Views: $views',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleFooter(DateTime updatedAt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Last updated: ${DateFormat('MMMM dd, yyyy').format(updatedAt)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
