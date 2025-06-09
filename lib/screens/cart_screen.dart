import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'payment.dart';
import 'detail.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _localCartItems;
  bool chooseAll = false;

  final backgroundColor = const Color(0xffe8f3f1);
  final accentColor = const Color(0xFF00B4A6);

  @override
  void initState() {
    super.initState();
    _localCartItems = List.from(widget.cartItems);
    chooseAll = _localCartItems.isNotEmpty &&
        _localCartItems.every((item) => item.isSelected);
  }

  void toggleChooseAll(bool? value) {
    setState(() {
      chooseAll = value ?? false;
      for (var item in _localCartItems) {
        item.isSelected = chooseAll;
      }
    });
  }

  void updateQuantity(String id, bool increase) {
    setState(() {
      final item = _localCartItems.firstWhere((item) => item.id == id);
      if (increase) {
        item.quantity++;
      } else {
        if (item.quantity > 1) item.quantity--;
      }
    });
  }

  void removeItem(String id) {
    setState(() {
      _localCartItems.removeWhere((item) => item.id == id);
      chooseAll = _localCartItems.isNotEmpty &&
          _localCartItems.every((item) => item.isSelected);
    });
  }

  double get totalPrice {
    return _localCartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Widget buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Checkbox(
                value: item.isSelected,
                onChanged: (value) {
                  setState(() {
                    item.isSelected = value ?? false;
                    chooseAll = _localCartItems.every((i) => i.isSelected);
                  });
                },
                activeColor: accentColor,
              ),
              Container(
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => updateQuantity(item.id, true),
                    ),
                    Text(item.quantity.toString(),
                        style: const TextStyle(fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => updateQuantity(item.id, false),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20),
                onPressed: () => removeItem(item.id),
                color: const Color.fromARGB(255, 186, 12, 12),
              ),
            ],
          ),
          const SizedBox(width: 30),
          ClipRRect(
            child: Image.network(
              item.imageUrl,
              width: 110,
              height: 130,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )),
                const SizedBox(height: 6),
                Text(
                  'Rp ${item.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: ProductModel(
                            id: item.product.id,
                            nameProduct: item.product.nameProduct,
                            imageUrl: item.product.imageUrl,
                            price: item.product.price,
                            stock: item.product.stock,
                            description: item.product.description,
                            types: item.product.types,
                          ),
                          onAddToCart: () {
                            setState(() {
                              _localCartItems.add(item);
                            });
                          },
                          cartItems: _localCartItems,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'see detail..',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 103, 103, 103),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _localCartItems);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () {
              Navigator.pop(context, _localCartItems);
            },
          ),
          title: const Text('Cart',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        body: _localCartItems.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _localCartItems.length,
                      itemBuilder: (context, index) =>
                          buildCartItem(_localCartItems[index]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: chooseAll,
                          onChanged: toggleChooseAll,
                          activeColor: accentColor,
                        ),
                        const Text('Choose All'),
                        const Spacer(),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              final selected = _localCartItems
                                  .where((item) => item.isSelected)
                                  .toList();
                              if (selected.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please Choose the Product to Buy')),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentScreen(items: selected),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Buy Now',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
