import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  final String title;
  final String color;
  final double price;
  String? imageUrl = 'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906';
  int quantity;

  CartItem({
    Key? key,
    required this.title,
    required this.color,
    required this.price,
    this.imageUrl,
    this.quantity = 1, // Default quantity set to 1
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Color: ${widget.color}', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  Text('₹${widget.price}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (widget.quantity > 1) {
                        widget.quantity--;
                      }
                    });
                  },
                ),
                Text('${widget.quantity}', style: textTheme.titleMedium),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.quantity++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
