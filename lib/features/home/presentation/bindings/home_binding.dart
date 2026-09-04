// lib/features/home/presentation/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:luranapp/features/product/domain/repositories/product_repository_interface.dart';
import 'package:luranapp/features/product/data/repositories/product_repository.dart';
import 'package:luranapp/features/offer/domain/repositories/offer_repository_interface.dart';
import 'package:luranapp/features/offer/data/repositories/offer_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorio de productos
    if (!Get.isRegistered<ProductRepositoryInterface>()) {
      Get.lazyPut<ProductRepositoryInterface>(
        () => ProductRepository(),
        fenix: true,
      );
    }
    
    // Repositorio de ofertas
    if (!Get.isRegistered<OfferRepositoryInterface>()) {
      Get.lazyPut<OfferRepositoryInterface>(
        () => OfferRepository(),
        fenix: true,
      );
    }
    
    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<ProductRepositoryInterface>(),
        Get.find<OfferRepositoryInterface>(),
      ),
    );
  }
}