import 'dart:developer';
import 'package:get/get.dart';
import '../../model/address.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class AddressController extends GetxController {
  final FirestoreService fireStore = FirestoreService();
  final AuthService authService = Get.find<AuthService>();

  // Observable list for addresses
  RxList<AddressModel> addressList = <AddressModel>[].obs;

  // Observable for loading state
  RxBool isLoading = true.obs;

  // Stream for addresses
  Stream<List<AddressModel>> get addressStream {
    final userId = authService.currentUser!.uid;
    return fireStore.getAddressStream(userId).map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              AddressModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;
      await fireStore.deleteAddress(authService.currentUser!.uid, addressId);
    } catch (e) {
      log('Error deleting addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
