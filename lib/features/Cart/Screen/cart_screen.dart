import 'package:conquest/features/Cart/Screen/CartItem.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.secondaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('My Cart', style: textTheme.titleLarge?.copyWith(color: Colors.black)),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/user_profile_image.jpg'),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                CartItem(
                  title: 'Polo Shirt For Men',
                  color: 'Red',
                  price: 30.0,
                  imageUrl: 'https://example.com/polo_shirt.jpg',
                  quantity: 1,
                ),
                CartItem(
                  title: 'Scott Bag',
                  color: 'Black',
                  price: 42.0,
                  imageUrl: 'https://example.com/scott_bag.jpg',
                  quantity: 1,
                ),
                CartItem(
                  title: 'Pro Tour Shoes',
                  color: 'Blue',
                  price: 150.0,
                  imageUrl: 'https://example.com/pro_tour_shoes.jpg',
                  quantity: 1,
                ),
                CartItem(
                  title: 'T250 Headphones',
                  color: 'Brown',
                  price: 98.0,
                  imageUrl: 'https://example.com/headphones.jpg',
                  quantity: 1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('\$320', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text('Order Now', style: textTheme.labelLarge?.copyWith(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
