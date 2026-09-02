import 'package:get/get.dart';
import 'package:luranapp/features/business_dashboard/presentation/controllers/business_dashboard_controller.dart';

class BusinessDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessDashboardController>(
      BusinessDashboardController.new,
      fenix: true,
    );
  }
}
