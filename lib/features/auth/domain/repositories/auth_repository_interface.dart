// lib/features/auth/domain/repositories/auth_repository_interface.dart
import '../entities/user.dart';

abstract class AuthRepositoryInterface {
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });
  
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });
  
  Future<void> signOut();
  
  Future<UserEntity?> getCurrentUser();
  
  Stream<UserEntity?> get authStateChanges;
  
  // Nuevo método para actualizar perfil
  Future<UserEntity> updateUserProfile({
    required String userId,
    required String username,
    required String pais,
    required String ciudad,
  });
}