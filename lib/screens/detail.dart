import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // Product Name and Description
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kapsul 250 mg',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hazel dengan mage daktir',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // Price
              const Text(
                'Rp 95.000,00',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Product Info Table
              Table(
                border: TableBorder.all(color: Colors.grey[300]!),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Penicillin'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Antibiotic'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tablet'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'stock: 9',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // Product Description
              const Text(
                'Product Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product['description'],
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Uses List
              const Text(
                'Amoxicillin is typically used to treat:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        '1. Respiratory tract infections (such as sore throat, bronchitis, and pneumonia)'),
                    // Add more list items as needed
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Read More
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF199A8E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
