import 'package:flutter/material.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> cartItems = [
    CartItem('APPLE iPhone 8', 'Black, 64 GB', 380.0, 1, 'https://images-cdn.ubuy.co.in/6596f3716048e448bc6379aa-pre-owned-iphone-8-plus-64gb-gold.jpg'),
    CartItem('Nike Track suit', 'Red', 500.0, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMDUHqpxbmnsYW0ji9mhtgx9KBmIDj0964fQ&s'),
    CartItem('Iphone 12', '128gb and 256gb', 900.0, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTB2qKl--OlsgpwiXxqblEL9Fj_SBUVmo1K-A&s'),
  ];

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  item: cartItems[index],
                  onQuantityChanged: (quantity) {
                    setState(() {
                      cartItems[index].quantity = quantity;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checkout \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle checkout action
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;

  const CartItemWidget({super.key, required this.item, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            item.imagePath,
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (item.quantity > 1) {
                    onQuantityChanged(item.quantity - 1);
                  }
                },
                icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  onQuantityChanged(item.quantity + 1);
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              ),
            ],
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String title;
  final String subtitle;
  final double price;
  int quantity;
  final String imagePath;

  CartItem(this.title, this.subtitle, this.price, this.quantity, this.imagePath);
}