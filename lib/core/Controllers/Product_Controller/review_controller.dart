import 'package:conquest/core/repository/review_repository.dart';
import 'package:get/get.dart';
import '../../model/product_models/review.dart';
import '../../model/user.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final auth = AuthService.instance;
  final FirestoreService _firestoreService = FirestoreService();
  var userModel = Rxn<UserModel>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = auth.currentUser;
    if (user != null) {
      UserModel? fetchedUserModel =
          await _firestoreService.getUserDetails(user.uid);
      if (fetchedUserModel != null) {
        userModel.value = fetchedUserModel;
      }
    }
  }

  Future<void> addReview(String productId, String title, String review,
      double rating, String userName, String userId) async {
    isLoading.value = true;

    try {
      await ReviewRepository.instance.addReview(
        userId: userId,
        productId: productId,
        rating: rating,
        title: title,
        reviewText: review,
        username: userName,
      );
      Get.snackbar('Success', 'Review added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add review. Please try again');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }


  Stream<List<ReviewModel>> streamProductReviews(String productId) {
    return ReviewRepository.instance.streamProductReviews(productId);
  }

  Stream<Map<String, dynamic>> streamRatingSummary(String productId) {
    return ReviewRepository.instance.streamRatingSummary(productId);
  }

}
