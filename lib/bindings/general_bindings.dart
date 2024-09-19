import 'package:get/get.dart';
import '../core/Controllers/Product_Controller/variation_controller.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(VariationController());
  }
}