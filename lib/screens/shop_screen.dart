import 'package:flutter/material.dart';
import 'cart_screen.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'detail.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<ProductModel> products = [
    ProductModel(
      id: '1',
      name: 'Paracetamol 500 mg',
      price: 30000,
      image: 'assets/images/paracetamol1.png',
      description: '''
Paracetamol 500 mg adalah obat pereda nyeri dan penurun demam yang umum digunakan. Setiap tablet atau kaplet mengandung 500 mg paracetamol.

Indikasi: Meredakan nyeri ringan hingga sedang (misalnya sakit kepala, sakit gigi, nyeri otot, nyeri haid) dan menurunkan demam.

Dosis Umum: Dewasa: 1-2 tablet/kaplet setiap 4-6 jam, tidak melebihi 4 gram (8 tablet/kaplet) dalam 24 jam.

Perhatian: Jangan melebihi dosis yang dianjurkan karena dapat menyebabkan kerusakan hati. Hati-hati penggunaan pada penderita gangguan fungsi hati dan ginjal.
''',
      types: ['Antipiretik', 'Analgesik', 'Obat Bebas'],
      stock: 192,
    ),
    ProductModel(
      id: '2',
      name: 'Ibuprofen 400 mg',
      price: 40000,
      image: 'assets/images/ibuprofen.png',
      description: '''
Ibuprofen 400 mg adalah obat golongan antiinflamasi nonsteroid (OAINS) yang efektif untuk meredakan nyeri, menurunkan demam, dan mengurangi peradangan. Setiap tablet atau kaplet mengandung 400 mg ibuprofen. Obat ini bekerja dengan menghambat produksi prostaglandin, yaitu zat kimia dalam tubuh yang menjadi penyebab utama rasa nyeri, demam, dan peradangan.

Indikasi:

Meredakan nyeri: Sangat efektif untuk mengatasi berbagai jenis nyeri ringan hingga sedang, seperti sakit kepala (termasuk migrain), sakit gigi, nyeri otot, nyeri sendi, nyeri akibat cedera ringan, dan nyeri haid (dismenore).
Menurunkan demam: Membantu menurunkan suhu tubuh saat demam.
Mengurangi peradangan: Bermanfaat untuk kondisi yang melibatkan peradangan, seperti radang sendi ringan atau bengkak akibat cedera.
Dosis Umum Dewasa:

Dosis yang dianjurkan adalah 1 tablet (400 mg) setiap 4-6 jam, sesuai kebutuhan.
Penting untuk tidak melebihi dosis maksimal 2400 mg (6 tablet 400 mg) dalam waktu 24 jam.
Sebaiknya dikonsumsi setelah makan untuk membantu mengurangi risiko iritasi lambung.
Perhatian dan Peringatan:

Gangguan Lambung: Gunakan dengan hati-hati pada individu dengan riwayat penyakit maag, tukak lambung, atau masalah pencernaan lainnya, karena ibuprofen dapat meningkatkan risiko iritasi atau perdarahan lambung.
Gangguan Ginjal dan Hati: Hati-hati pada penderita gangguan fungsi ginjal atau hati.
Asma: Dapat memicu serangan asma pada beberapa penderita yang sensitif terhadap OAINS.
Penyakit Jantung dan Tekanan Darah Tinggi: Penggunaan jangka panjang atau dosis tinggi pada beberapa kasus dapat meningkatkan risiko masalah kardiovaskular.
Interaksi Obat: Hindari penggunaan bersamaan dengan OAINS lain (misalnya naproxen, aspirin dosis tinggi) atau obat pengencer darah tanpa konsultasi dokter.
Kehamilan dan Menyusui: Konsultasikan dengan dokter sebelum menggunakan obat ini jika Anda hamil atau menyusui.
Efek Samping Umum: Mual, muntah, diare, sembelit, sakit perut, pusing, atau ruam kulit. Jika efek samping berlanjut atau memburuk, segera hentikan penggunaan dan hubungi dokter.
Penting: Selalu ikuti petunjuk penggunaan pada kemasan obat atau sesuai anjuran dokter/apoteker. Jika nyeri tidak mereda atau demam tidak turun setelah beberapa hari penggunaan, segera konsultasikan ke tenaga medis.
''',
      types: ['Antiinflamasi Nonsteroid'],
      stock: 13,
    ),
    ProductModel(
      id: '3',
      name: 'Paracetamol 10 kaplet',
      price: 15000,
      image: 'assets/images/panadol1.png',
      description: 'Obat pereda nyeri ringan dan penurun panas.',
      types: ['Antipiretik', 'Analgesik'],
      stock: 20,
    ),
    ProductModel(
      id: '4',
      name: 'Sanmol 500 mg',
      price: 30000,
      image: 'assets/images/sanmol.png',
      description:
          'Sanmol efektif mengatasi demam dan nyeri pada anak-anak dan dewasa.',
      types: ['Antipiretik', 'Analgesik'],
      stock: 20,
    ),
    ProductModel(
      id: '5',
      name: 'Panadol Extra',
      price: 15000,
      image: 'assets/images/panadol2.png',
      description:
          'Panadol Extra mengandung kafein untuk membantu meningkatkan efektivitas.',
      types: ['Antipiretik', 'Analgesik'],
      stock: 20,
    ),
  ];

  List<CartItem> cartItems = [];
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  List<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) {
      return products;
    } else {
      return products.where((product) {
        return product.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  void addToCart(ProductModel product) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.name == product.name);

      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(
          id: DateTime.now().toString(),
          name: product.name,
          imageUrl: product.image,
          price: product.price.toDouble(),
          product: product,
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
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                  BackButton(
                    color: Colors.black,
                  ),
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
                          setState(() {});
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
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search drugs, category...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 40),

              // Product grid
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: product,
                                      onAddToCart: () {
                                        addToCart(product);
                                        Navigator.pop(context);
                                      },
                                      cartItems: cartItems,
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
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                        child: Image.asset(product.image,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${product.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')},00',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              addToCart(product);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Product has been added to cart successfully."),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                                Icons.add_circle_outline,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
