// lib/features/product/presentation/bindings/product_binding.dart
import 'package:get/get.dart';
import '../../domain/repositories/product_repository_interface.dart';
import '../../data/repositories/product_repository.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepositoryInterface>(
      () => ProductRepository(),
    );
    
    Get.lazyPut<ProductController>(
      () => ProductController(Get.find<ProductRepositoryInterface>()),
    );
  }
}