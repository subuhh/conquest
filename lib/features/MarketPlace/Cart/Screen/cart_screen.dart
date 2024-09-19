import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/utils/helpers/helper_functions.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/Animation_Loaders/TAnimation_Page.dart';
import '../../../../utils/constants/colors.dart';
import 'CartItem.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final controller = CartController.instance;

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('My Cart',
            style: TTextTheme.lightTextTheme.titleLarge
                ?.copyWith(color: Colors.white)),
      ),
      body: Obx(
        () {
          final emptyWidget = TAnimationPage(
            asset: 'assets/animation/empty_cart.json',
            height: 350,
            width: 350,
            titleText: 'Whoops! Wishlist is Empty...',
            buttonText: 'Lets add some',
            onPressed: () => Get.back(),
          );

          if (controller.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            return ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return CartItem(
                  cartItem: item,
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₹320',
                  style: TTextTheme.lightTextTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'your order summary',
                  style: TTextTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blueAccent),
                ),
              ],
            ),
            SizedBox(
              width: THelperFunctions.screenWidth(context) * 0.35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Center(
                  child: Text(
                    'Order Now',
                    style: TTextTheme.lightTextTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
