// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'article_screen.dart';
import '../models/article_model.dart';
import '../providers/user_provider.dart';
import 'saved_articles_screen.dart';

enum _ArticleViewMode { latest, trending }

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
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  _ArticleViewMode _currentViewMode = _ArticleViewMode.latest;
  int _currentPage = 0;
  final int _articlesPerPage = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserData();
    });
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      isLoading = true;
      hasError = false;
      articles = [];
    });
    try {
      Query<Map<String, dynamic>> query;

      if (_currentViewMode == _ArticleViewMode.latest) {
        query = _firestore
            .collection('articles')
            .orderBy('CreatedAt', descending: true);
      } else {
        query = _firestore
            .collection('articles')
            .orderBy('Views', descending: true);
      }

      final snapshot = await query.get();

      setState(() {
        articles =
            snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
        isLoading = false;
        _currentPage = 0; // Reset page when articles are re-fetched
      });
    } catch (e) {
      debugPrint('Error loading articles: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
              _searchArticles(),
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
                backgroundColor: const Color(0xFF119C8E),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(defaultImage),
                )),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getGreetingMessage(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700])),
                  Text(userProvider.userName,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border,
                  color: Color.fromRGBO(17, 156, 142, 1), size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavedArticlesScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLatestArticlesSection() {
    String sectionTitle = _currentViewMode == _ArticleViewMode.latest
        ? "Latest Articles"
        : "Trending Articles";

    // Hitung total halaman berdasarkan filteredArticles, bukan articles
    // Ini akan dihitung lagi di _buildArticleList, tapi perlu di sini untuk pagination control.
    final totalFilteredItems = searchQuery.isEmpty
        ? articles.length
        : articles.where((article) {
            final query = searchQuery.toLowerCase();
            final title = article.title.toLowerCase();
            final body = article.body.toLowerCase();
            return title.contains(query) || body.contains(query);
          }).length;
    final totalPages = (totalFilteredItems / _articlesPerPage).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<_ArticleViewMode>(
              value: _currentViewMode,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              underline: Container(
                height: 2,
                color: const Color(0xFF119C8E),
              ),
              onChanged: (_ArticleViewMode? newValue) {
                setState(() {
                  _currentViewMode = newValue!;
                  _currentPage = 0;
                });
                _fetchArticles();
              },
              items: const <DropdownMenuItem<_ArticleViewMode>>[
                DropdownMenuItem(
                  value: _ArticleViewMode.latest,
                  child: Text("Latest Articles"),
                ),
                DropdownMenuItem(
                  value: _ArticleViewMode.trending,
                  child: Text("Trending Articles"),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                  color: Colors.grey[700],
                  disabledColor: Colors.grey[400],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    '${_currentPage + 1}/${totalPages == 0 ? 1 : totalPages}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  // Nonaktifkan jika di halaman terakhir atau tidak ada item
                  onPressed: _currentPage < totalPages - 1 && totalPages > 0
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                  color: Colors.grey[700],
                  disabledColor: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
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

    // Filter artikel berdasarkan searchQuery (tidak case-sensitive)
    final filteredArticles = searchQuery.isEmpty
        ? articles
        : articles.where((article) {
            final query = searchQuery.toLowerCase();
            final title = article.title.toLowerCase();
            final body = article.body.toLowerCase();
            return title.contains(query) || body.contains(query);
          }).toList();

    // --- BAGIAN PAGINATION YANG DIPERBAIKI SECARA ROBUST ---
    final int totalItems = filteredArticles.length;
    final int totalPages = (totalItems / _articlesPerPage).ceil();

    // Menyesuaikan _currentPage agar tidak melebihi batas totalPages baru
    if (totalItems == 0) {
      _currentPage = 0; // Jika tidak ada item, selalu di halaman 0
    } else if (_currentPage >= totalPages) {
      // Jika _currentPage terlalu tinggi untuk filteredArticles yang baru,
      // reset ke halaman terakhir yang valid.
      _currentPage = totalPages - 1;
    }
    // _currentPage secara implisit >= 0 karena diinisialisasi sebagai 0 dan hanya bertambah/berkurang

    final int startIndex = _currentPage * _articlesPerPage;
    final int endIndex = (startIndex + _articlesPerPage).clamp(0, totalItems);

    // Final check untuk kondisi tidak valid sebelum sublist
    if (startIndex < 0 || startIndex >= totalItems && totalItems > 0) {
      return Center(
        child: Text(
          searchQuery.isEmpty
              ? 'No articles found for this selection or page.'
              : 'No articles found matching "$searchQuery".',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Jika tidak ada artikel setelah filter/paginasi (misal totalItems = 0)
    if (totalItems == 0) {
      return Center(
        child: Text(
          searchQuery.isEmpty
              ? 'No articles found for this selection or page.'
              : 'No articles found matching "$searchQuery".',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 16, color: Colors.grey),
        ),
      );
    }
    // --- AKHIR BAGIAN PAGINATION YANG DIPERBAIKI SECARA ROBUST ---

    final paginatedArticles = filteredArticles.sublist(startIndex, endIndex);

    if (paginatedArticles.isEmpty) {
      return Center(
        child: Text(
          searchQuery.isEmpty
              ? 'No articles found for this selection or page.'
              : 'No articles found matching "$searchQuery".',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: paginatedArticles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = paginatedArticles[index];
        return _articleCard(article);
      },
    );
  }

  Widget _searchArticles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search articles...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = '';
                      _currentPage = 0; // Reset halaman saat clear search
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xFF119C8E),
              width: 3.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: const Color(0xFF119C8E).withOpacity(0.7),
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            _currentPage = 0; // Reset halaman saat mengetik search
          });
        },
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
        height: 180,
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
