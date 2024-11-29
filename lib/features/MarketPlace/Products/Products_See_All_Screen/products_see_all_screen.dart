import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/utils/Loading/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/Product_Controller/product_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../ProductCard/productCardSmall.dart';

class ProductsSeeAllScreen extends StatefulWidget {
  const ProductsSeeAllScreen(
      {super.key, this.categoryId, required this.name, this.products});

  final String? categoryId;
  final String name;

  final List<ProductModel>? products;

  @override
  State<ProductsSeeAllScreen> createState() => _ProductsSeeAllScreenState();
}

class _ProductsSeeAllScreenState extends State<ProductsSeeAllScreen> {
  final _productController = ProductController.instance;
  List<ProductModel>? products;

  void initState() {
    super.initState();
    getCategoryProducts();
  }

  void getCategoryProducts() {
    if (widget.categoryId != null) {
      products = _productController.allProducts.where((product) {
        // Check if the product's categories contain the specific category string
        return product.categoryId
            .contains(widget.categoryId?.toLowerCase() ?? '');
      }).toList();
    }

    if (widget.products != null) {
      if (widget.name == 'Trending Now') {
        products = _productController.featuredProducts;
      } else {
        products = _productController.allProducts.where((product) {
          // Check if the product's categories contain the specific category string
          return product.categoryId
              .contains(widget.categoryId?.toLowerCase() ?? '');
        }).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: TColors.white,
        title: Text('${widget.name}'),
      ),
      body: Obx(() {
        if (_productController.isLoading.value) {
          return ShimmerLoading.shimmerGridView();
        }

        if (products == null || products!.isEmpty) {
          return Center(
            child:
                const Text('There is no products in this category until now'),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: GridView.builder(
            itemCount: products!.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 2,
              mainAxisExtent: 325,
            ),
            itemBuilder: (_, index) => ProductCardSmall(
              imageUrl: products![index].thumbnail,
              title: products![index].title,
              oldPrice: products![index].price.toString(),
              newPrice: products![index].salePrice.toString(),
              productModel: products![index],
            ),
          ),
        );
      }),
    );
  }
}
