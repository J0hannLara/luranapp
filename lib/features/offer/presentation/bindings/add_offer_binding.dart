// lib/features/offer/presentation/bindings/add_offer_binding.dart
import 'package:get/get.dart';
import '../../../product/domain/repositories/product_repository_interface.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../businesses/domain/repositories/business_repository_interface.dart';
import '../../../businesses/data/repositories/business_repository.dart';
import '../../domain/repositories/offer_repository_interface.dart';
import '../../data/repositories/offer_repository.dart';
import '../controllers/add_offer_controller.dart';

class AddOfferBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorios
    Get.lazyPut<ProductRepositoryInterface>(
      () => ProductRepository(),
      fenix: true,
    );
    
    Get.lazyPut<BusinessRepositoryInterface>(
      () => BusinessRepository(),
      fenix: true,
    );
    
    Get.lazyPut<OfferRepositoryInterface>(
      () => OfferRepository(),
    );
    
    // Controller
    Get.lazyPut<AddOfferController>(
      () {
        final businessId = Get.parameters['businessId'] ?? '';
        return AddOfferController(
          Get.find<ProductRepositoryInterface>(),
          Get.find<BusinessRepositoryInterface>(),
          Get.find<OfferRepositoryInterface>(),
          businessId,
        );
      },
      fenix: true,
    );
  }
}