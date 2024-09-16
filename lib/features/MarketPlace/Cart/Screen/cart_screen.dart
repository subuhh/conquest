import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../Checkout/checkoutScreen.dart';
import '../LIstForCart/CartList.dart';
import 'CartItem.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: TColors.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('My Cart',
            style: textTheme.titleLarge?.copyWith(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: cartData.length,
            itemBuilder: (context, index) {
              final item = cartData[index];
              return CartItem(
                title: item['title'],
                color: item['color'],
                imageUrl: item['imageUrl'],
                quantity: item['quantity'],
                orignalPrice: item['originalPrice'],
                dicountedPrice: item['discountedPrice'],
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total ₹320',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),

                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    THelperFunctions.navigateToScreen(
                        context, Checkoutscreen());
                  },
                  child: Text('Order Now',
                      style:
                          textTheme.titleMedium?.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
