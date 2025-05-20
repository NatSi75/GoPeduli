import 'package:flutter/material.dart';
import 'cart_screen.dart';
import '../models/cart_model.dart';
import 'detail.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Paracetamol 500 mg',
      'price': 30000,
      'image': 'assets/images/paracetamol1.png',
      'description': 'Paracetamol digunakan untuk meredakan demam dan nyeri.'
    },
    {
      'name': 'Ibuprofen 400 mg',
      'price': 35000,
      'image': 'assets/images/ibuprofen.png',
      'description':
          'Ibuprofen digunakan untuk mengurangi peradangan dan nyeri.'
    },
    {
      'name': 'Paracetamol 10 kaplet',
      'price': 15000,
      'image': 'assets/images/panadol1.png',
      'description': 'Obat pereda nyeri ringan dan penurun panas.'
    },
    {
      'name': 'Sanmol 500 mg',
      'price': 30000,
      'image': 'assets/images/sanmol.png',
      'description':
          'Sanmol efektif mengatasi demam dan nyeri pada anak-anak dan dewasa.'
    },
    {
      'name': 'Panadol Extra',
      'price': 15000,
      'image': 'assets/images/panadol2.png',
      'description':
          'Panadol Extra mengandung kafein untuk membantu meningkatkan efektivitas.'
    },
  ];

  List<CartItem> cartItems = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      final index =
          cartItems.indexWhere((item) => item.name == product['name']);

      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(
          id: DateTime.now().toString(),
          name: product['name'],
          imageUrl: product['image'],
          price: product['price'].toDouble(),
        ));
      }
    });
  }

  int getTotalQuantity() {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back),
                  const Text(
                    'Shop',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.shopping_cart_outlined, size: 28),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CartScreen(cartItems: cartItems),
                            ),
                          );
                          setState(() {}); // Refresh UI agar badge cart update
                        },
                      ),
                      if (getTotalQuantity() > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${getTotalQuantity()}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search drugs, category...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              const SizedBox(height: 16),

              // Product grid
              Expanded(
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                              onAddToCart: () => addToCart(product),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xffe8f3f1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.asset(product['image'],
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rp ${product['price'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')},00',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () => addToCart(product),
                                    child: const Icon(Icons.add_circle_outline,
                                        color: Colors.teal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
