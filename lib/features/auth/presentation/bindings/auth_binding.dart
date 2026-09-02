// lib/features/auth/presentation/bindings/auth_binding.dart
import 'package:get/get.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar el repositorio
    Get.lazyPut<AuthRepositoryInterface>(
      () => AuthRepository(),
    );
    
    // Registrar el controller
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<AuthRepositoryInterface>()),
    );
  }
}