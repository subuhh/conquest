import 'package:conquest/features/shop/screens/product-details/widgets/Product_Meta_data.dart';
import 'package:conquest/features/shop/screens/product-details/widgets/product_attributes.dart';
import 'package:conquest/features/shop/screens/product-details/widgets/product_detail_image-slider.dart';
import 'package:conquest/features/shop/screens/product-details/widgets/rating_share_widget.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/ProductPriceText.dart';
import '../../../../common/widgets/ProductTitleText.dart';
import '../../../../common/widgets/RoundedContainer.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///1 - Product Image Slider
            ProductImageSlider(),

            /// Product Details
            ProductMetaData(),

            ///Attributes
          ProductAttributes()

          /// Checkout Button


          ///Description


            /// Reviews
          ],
        ),
      ),
    );
  }
}

