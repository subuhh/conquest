import 'package:get/get.dart';
import '../../common/widgets/custom_snackbar.dart';
import '../services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Method to submit a report
  Future<void> submitReport(
      {required String reportedUserId,
      required String reportType,
      required String reportByUserId,
      String? description}) async {
    try {
      isLoading.value = true;
      await _reportService.addReport(
        reportedUserId: reportedUserId,
        reportType: reportType,
        reportByUserId: reportByUserId,
      );
      Get.back();
      showSnackBar('Success',
          'The user has been successfully reported. We take all reports seriously and will review it shortly.');
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to submit report $e';
      print(errorMessage.value);
    }
  }
}
