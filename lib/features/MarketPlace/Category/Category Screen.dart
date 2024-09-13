import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../Products/ProductCard/ProductCardLarge.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        title: Text('Category Title', style: Theme
            .of(context)
            .textTheme
            .titleMedium,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Productcardlarge(title: 'Title',
              isCategoryCard: true,
              color: 'color',
              orignalPrice: 50,
              discountedPrice: 40);
        },

      ),
    );
  }
}