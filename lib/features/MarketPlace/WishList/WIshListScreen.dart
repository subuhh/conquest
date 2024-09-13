import 'package:conquest/features/MarketPlace/Products/ProductCard/ProductCardLarge.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Wishlistscreen extends StatelessWidget {
  const Wishlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        title: Text('WishList',style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context,index) {
          return Productcardlarge(title: 'Title', color: 'color', orignalPrice: 50, discountedPrice: 40,isCategoryCard: false,);
        },

      ),
    );
  }
}
