import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import 'package:conquest/core/Controllers/marketplace_controller.dart';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:conquest/core/model/banner.dart';
import 'package:get/get.dart';
import '../services/firestore_service.dart';
import 'Product_Controller/product_controller.dart';

class HomePageController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final productController = Get.put(ProductController());
  final marketPlaceController = Get.put(MarketplaceController());
  var banners = <BannerModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchHomePageData();
    initializeControllers();
    super.onInit();
  }

  Future<void> initializeControllers() async {
    await Get.putAsync(() async {
      final userController = UserController();
      return userController;
    });
    Get.put(RecipeController());
  }

  Future<void> fetchHomePageData() async {
    try {
      isLoading(true);
      banners.assignAll(
          await _firestoreService.fetchBanners(targetScreen: 'home'));
    } finally {
      isLoading(false);
    }
  }
}
