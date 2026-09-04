// lib/features/business_dashboard/presentation/bindings/business_dashboard_binding.dart
import 'package:get/get.dart';
import 'package:luranapp/features/businesses/domain/repositories/business_repository_interface.dart';
import 'package:luranapp/features/businesses/data/repositories/business_repository.dart';
import '../controllers/business_dashboard_controller.dart';

class BusinessDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorio
    Get.lazyPut<BusinessRepositoryInterface>(
      () => BusinessRepository(),
      fenix: true,
    );
    
    Get.lazyPut<BusinessDashboardController>(
      () {
        // Obtener el businessId de los parámetros de la ruta
        final businessId = Get.parameters['id'] ?? '';
        return BusinessDashboardController(
          Get.find<BusinessRepositoryInterface>(),
          businessId,
        );
      },
      fenix: true,
    );
  }
}