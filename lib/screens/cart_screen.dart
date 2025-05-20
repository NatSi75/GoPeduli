import 'package:flutter/material.dart';
import '../models/cart_model.dart'; // import your CartItem class here

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
        title: const Text('Cart'),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          });
                        },
                      ),
                      Image.asset(item.imageUrl,
                          width: 60, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text('Rp ${item.price.toStringAsFixed(0)}'),
                            const Text('see detail..',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
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
          Row(
            children: [
              Checkbox(
                value: chooseAll,
                onChanged: toggleChooseAll,
              ),
              const Text('Choose All'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final selectedItems = widget.cartItems
                      .where((item) => item.isSelected)
                      .toList();
                  // TODO: Handle checkout logic
                  print('Buying: ${selectedItems.length} item(s)');
                },
                child: const Text('Buy Now'),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
