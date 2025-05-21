import 'package:flutter/material.dart';
import 'article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> articles = [
    {
      'author': 'Yasemin Nicola Sakay',
      'title': 'Can fiber help you lose weight? Dietitian answers 5 key questions',
      'time': '5 min read',
      'imageUrl': 'assets/images/latest1.png',
      'content': 'When it comes to weight loss, many people track their macros — i.e., their proteins, fats, and carbohydrates. However, as a humble nutrient, fiber is often overlooked. But what if this is the missing ingredient to weight loss success? Can fiber supplements replace whole foods? In this podcast, a nutritionist answers readers\' questions about fiber and more. \n\nNowadays, the internet is awash with articles, charts, and recipes centered around eating more protein — anything from a 30-gram-protein breakfast to high-protein drinks and more — to naturally lose weight. And although the key to achieving good weight loss results is indeed a higher protein intake, there is a nutrient that is often overlooked: fiber. \n\nFiber is crucial not only for digestive functioning but overall health. Studies have shown it can lower LDL cholesterol, reduce blood pressure, and protect against heart disease. Newer research also shows that fiber may promote weight loss and enhance sensitivity to insulin. \n\nHowever, statistics show that less than 5% of Americans realistically meet their recommended daily fiber intake, which is on average up to 34 grams (g)Trusted Source for adult men and about 28 g for adult women. So, how can we eat more fiber? \n\nIn this episode of In Conversation, we\'ll be tackling burning questions such as: What is fiber, and why is it important for our bodies? How can we tell whether we are eating enough fiber? Is it right to call fiber nature\'s Ozempic? \n\nWe\'ll differentiate between soluble and insoluble fiber while discussing the ideal daily intake for different people. We\'ll also touch on how fiber supplements like psyllium husk compare with whole foods, weighing their benefits for our well-being. We will also look at how fiber plays a crucial role in fighting insulin resistance and its potential role in supporting weight management goals. \n\nTo discuss this and more, we\'re joined by registered dietitian Lisa Valente, MS, RD. Lisa holds a Master of Science in nutrition communications from the Friedman School of Nutrition Science and Policy at Tufts University, and she completed her dietetic internship at Massachusetts General Hospital.'
    },
    {
      'author': 'Kelsey Costa, MS, RDN',
      'title': 'Common sugar substitute may affect brain and blood vessel health',
      'time': '3 min read',
      'imageUrl': 'assets/images/latest2.png',
      'content': 'Just a single serving of an erythritol-sweetened beverage may harm brain and blood vessel health, according to a new cellular study.'
    },
    {
      'author': 'Jillian Kubala, MS, RD',
      'title': 'Managing chronic inflammation with psoriasis',
      'time': '6 min read',
      'imageUrl': 'assets/images/latest3.png',
      'content': 'Although the exact cause of psoriasis is unknown, doctors consider it an immune-mediated inflammatory disease. This means that inflammation is at the root of this condition.'
    },
  ];

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

  final List<Map<String, dynamic>> featuredArticles = [
    {
      'author': 'Yakub Krokodilo, RDN',
      'title': 'The 10 Best Supplements for Heart Health',
      'time': '7 min read',
      'imageUrl': 'assets/images/featured1.png',
      'content': 'Certain supplements may help promote heart health when paired with a balanced diet and healthy lifestyle.',
      'featuredTag': 'Editor\'s Pick'
    },
    {
      'author': 'Jillian Kubala, MS, RD',
      'title': '12 Science-Backed Benefits of Meditation',
      'time': '8 min read',
      'imageUrl': 'assets/images/featured2.png',
      'content': 'Meditation has many benefits that can improve your mental and physical health from reducing stress to improving sleep.',
      'featuredTag': 'Trending'
    },
    {
      'author': 'Kathy W. Warwick, RDN',
      'title': 'The 12 Best Foods for Healthy Skin',
      'time': '6 min read',
      'imageUrl': 'assets/images/featured3.png',
      'content': 'What you eat can significantly affect your skin health. Here are 12 of the best foods to keep your skin healthy.',
      'featuredTag': 'Must Read'
    },
    {
      'author': 'Ryan Raman, MS, RD',
      'title': 'The 14 Best Foods to Increase Blood Flow and Circulation',
      'time': '5 min read',
      'imageUrl': 'assets/images/featured4.png',
      'content': 'Poor circulation can cause unpleasant symptoms, but these foods can help improve blood flow and circulation.',
      'featuredTag': 'Health Tips'
    },
  ];

  final List<Map<String, dynamic>> popularArticles = [
    {
      'author': 'Daniel Yetman',
      'title': 'How to Lower Blood Pressure Immediately in an Emergency',
      'time': '4 min read',
      'imageUrl': 'assets/images/popular1.png',
      'content': 'Learn what to do in a hypertensive crisis when your blood pressure readings are dangerously high.',
      'views': '125K views'
    },
    {
      'author': 'Adrienne Santos-Longhurst',
      'title': 'How to Recognize the Early Signs of Diabetes',
      'time': '5 min read',
      'imageUrl': 'assets/images/popular2.png',
      'content': 'Early detection and treatment of diabetes can decrease the risk of developing complications.',
      'views': '98K views'
    },
    {
      'author': 'Ann Pietrangelo',
      'title': '10 Early Signs of Alzheimer\'s Everyone Should Know',
      'time': '9 min read',
      'imageUrl': 'assets/images/popular3.png',
      'content': 'Memory loss that disrupts daily life may be a symptom of Alzheimer\'s or other dementia.',
      'views': '156K views'
    },
    {
      'author': 'Kristeen Cherney',
      'title': 'What Does It Mean When You Have a Headache Every Day?',
      'time': '6 min read',
      'imageUrl': 'assets/images/popular4.png',
      'content': 'Daily headaches can be caused by various factors. Here\'s when to see a doctor about frequent headaches.',
      'views': '87K views'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(15, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/profilepicture.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Good Morning,", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      const Text("William Afton", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              const Text("Continue Reading", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: continueReading.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = continueReading[index];
                    return _readingCard(item['title'], item['time'], item['imageUrl']);
                  },
                ),
              ),
              const SizedBox(height: 20),
              DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TabBar(
                      labelColor: Colors.teal,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      indicatorColor: Colors.teal,
                      tabs: [
                        Tab(text: "Latest"),
                        Tab(text: "Featured"),
                        Tab(text: "Popular"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        children: [
                          _buildArticleList(articles),
                          _buildArticleList(featuredArticles),
                          _buildArticleList(popularArticles),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readingCard(String title, String time, String imageUrl) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageUrl, width: 140, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(
            title, 
            style: 
            const TextStyle(
              fontSize: 13, 
              fontWeight: 
              FontWeight.w600), 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
          const SizedBox(height: 3),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildArticleList(List<Map<String, dynamic>> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = list[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleScreen(
                  title: article['title'],
                  author: article['author'],
                  date: article['time'],
                  imageUrl: article['imageUrl'],
                  content: article['content'],
                ),
              ),
            );
          },
          child: _articleCard(
            author: article['author'],
            title: article['title'],
            time: article['time'],
            imageUrl: article['imageUrl'],
            content: article['content'],
          ),
        );
      },
    );
  }

  Widget _articleCard({
    required String author,
    required String title,
    required String time,
    required String imageUrl,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(author, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(content, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
