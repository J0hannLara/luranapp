// lib/config/dependencies/initial_binding.dart
import 'package:get/get.dart';
import 'package:luranapp/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:luranapp/features/auth/data/repositories/auth_repository.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar repositorios
    Get.lazyPut<AuthRepositoryInterface>(
      () => AuthRepository(),
      fenix: true, // Mantener vivo mientras la app esté activa
    );
    
    // Registrar controllers principales
    Get.put<AuthController>(
      AuthController(Get.find<AuthRepositoryInterface>()),
      permanent: true, // Controller permanente
    );
  }
}