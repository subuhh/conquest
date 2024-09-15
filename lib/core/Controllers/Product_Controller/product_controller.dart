import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/core/repository/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    fetchProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      isLoading.value = true;

      final products = await productRepository.fetchFeaturedProducts();

      featuredProducts.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch featured products');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;

      final products = await productRepository.fetchAllProducts();

      allProducts.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch products');
    } finally {
      isLoading.value = false;
    }
  }
}
