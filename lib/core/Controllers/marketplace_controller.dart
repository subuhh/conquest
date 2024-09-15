import 'package:get/get.dart';
import 'package:conquest/core/model/banner.dart';
import 'package:conquest/core/services/firestore_service.dart';

class MarketplaceController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var categories = <Map<String, dynamic>>[].obs;
  var banners = <BannerModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchMarketplaceData();
    super.onInit();
  }

  Future<void> fetchMarketplaceData() async {
    try {
      isLoading(true);
      categories.assignAll(await _firestoreService.fetchCategories());
      banners.assignAll(
          await _firestoreService.fetchBanners(targetScreen: 'marketplace'));
    } finally {
      isLoading(false);
    }
  }
}
