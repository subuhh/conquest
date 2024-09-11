import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/model/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/utils/constants/sizes.dart';

class ProductImageController extends GetxController {
  static ProductImageController get instance => Get.find();

  // Variables
  RxString selectedImage = ''.obs;

  // Get All Images from Product
  List<String> getAllProductImage(ProductModel product) {
    selectedImage.value = product.images[0];
    return product.images;
  }

  // Show Images PopUp
  void showEnlargeImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: TSizes.defaultSpace * 2,
                  horizontal: TSizes.defaultSpace,
                ),
                child: CachedNetworkImage(imageUrl: image),
              ),
              const SizedBox(height: 150)
            ],
          ),
        ),
      ),
    );
  }
}
