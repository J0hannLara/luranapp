// lib/features/business/presentation/bindings/business_management_binding.dart
import 'package:get/get.dart';
import '../../domain/repositories/business_repository_interface.dart';
import '../../data/repositories/business_repository.dart';
import '../controllers/business_management_controller.dart';

class BusinessManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessRepositoryInterface>(
      () => BusinessRepository(),
      fenix: true,
    );
    
    Get.lazyPut<BusinessManagementController>(
      () => BusinessManagementController(
        Get.find<BusinessRepositoryInterface>(),
      ),
    );
  }
}