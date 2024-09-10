import 'package:conquest/core/model/banner.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';

class HomePageController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var banners = <BannerModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchHomePageData();
    super.onInit();
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
