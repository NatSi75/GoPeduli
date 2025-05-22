import 'package:flutter/material.dart';
import '../models/cart_model.dart'; // import your CartItem class here
import 'payment.dart';
import 'detail.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool chooseAll = false;

  void toggleChooseAll(bool? value) {
    setState(() {
      chooseAll = value ?? false;
      for (var item in widget.cartItems) {
        item.isSelected = chooseAll;
      }
    });
  }

  void updateQuantity(String id, bool increase) {
    setState(() {
      final item = widget.cartItems.firstWhere((item) => item.id == id);
      if (increase) {
        item.quantity++;
      } else {
        if (item.quantity > 1) item.quantity--;
      }
    });
  }

  void removeItem(String id) {
    setState(() {
      widget.cartItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isSelected,
                        onChanged: (value) {
                          setState(() {
                            item.isSelected = value ?? false;
                            chooseAll = widget.cartItems
                                .every((item) => item.isSelected);
                          });
                        },
                        shape: const CircleBorder(), // Bikin checkbox bulat
                        checkColor: Colors.white, // Warna centang
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.teal; // Warna saat dicentang
                            }
                            return Colors
                                .grey.shade300; // Warna saat tidak dicentang
                          },
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Ubah sesuai kebutuhan
                        child: Image.asset(
                          item.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Rp ${item.price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')},00',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(168, 0, 0, 0),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: item.product,
                                      onAddToCart: () {
                                        // aksi ketika ditambahkan ke keranjang
                                      },
                                      cartItems: widget.cartItems,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'see detail..',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              if (item.quantity > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      updateQuantity(item.id, false),
                                )
                              else
                                const SizedBox(
                                    width:
                                        48), // supaya layout tidak berubah mendadak

                              Text(item.quantity.toString()),

                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => updateQuantity(item.id, true),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => removeItem(item.id),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Checkbox dan "Choose All"
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: chooseAll,
                        onChanged: toggleChooseAll,
                        activeColor: Colors.teal, // Warna checkbox ketika aktif
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Tombol "Buy Now"
                ElevatedButton(
                  onPressed: () {
                    final selectedItems = widget.cartItems
                        .where((item) => item.isSelected)
                        .toList();

                    if (selectedItems.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentScreen(items: selectedItems),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih produk dulu'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Warna background tombol
                    foregroundColor: Colors.white, // Warna teks
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0, // Menghilangkan shadow default
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
