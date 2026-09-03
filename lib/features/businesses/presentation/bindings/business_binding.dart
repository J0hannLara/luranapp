// lib/features/business/presentation/bindings/business_binding.dart
import 'package:get/get.dart';
import '../../domain/repositories/business_repository_interface.dart';
import '../../data/repositories/business_repository.dart';
import '../controllers/business_controller.dart';

class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessRepositoryInterface>(
      () => BusinessRepository(),
    );
    
    Get.lazyPut<BusinessController>(
      () => BusinessController(Get.find<BusinessRepositoryInterface>()),
    );
  }
}