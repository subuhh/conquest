import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';

class ProductImageController extends GetxController {
  static ProductImageController get instance => Get.find();

  // Variables
  RxString selectedProductImage = ''.obs;

  // Get All Images from Product
  List<String> getAllProductImage(ProductModel product) {
    // Use to store only unique images
    Set<String> images = {};

    // adding thumbnail image
    images.add(product.thumbnail);

    // assign thumbnail images as selected image
    selectedProductImage.value = product.thumbnail;

    // adding all images
    images.addAll(product.images);

    // adding all variations images
    // if (product.productVariations != null ||
    //     product.productVariations!.isNotEmpty) {
    //   for (var variation in product.productVariations!) {
    //     images.addAll(variation.images);
    //   }
    // }

    // Adding all variation images
    if (product.productVariations != null &&
        product.productVariations!.isNotEmpty) {
      for (var variation in product.productVariations!) {
        if (variation.images.isNotEmpty) {
          images.addAll(variation.images);
        }
      }
    }

    return images.toList();
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

  void showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pop(); // Close the dialog when tapping anywhere
          },
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
