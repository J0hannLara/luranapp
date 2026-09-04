// lib/features/business/presentation/bindings/business_registration_binding.dart
import 'package:get/get.dart';
import '../../domain/repositories/business_repository_interface.dart';
import '../../domain/repositories/sucursal_repository_interface.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/sucursal_repository.dart';
import '../controllers/business_registration_controller.dart';

class BusinessRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessRepositoryInterface>(
      () => BusinessRepository(),
    );
    
    Get.lazyPut<SucursalRepositoryInterface>(
      () => SucursalRepository(Get.find<BusinessRepositoryInterface>()),
    );
    
    Get.lazyPut<BusinessRegistrationController>(
      () => BusinessRegistrationController(
        Get.find<SucursalRepositoryInterface>(),
      ),
    );
  }
}