// lib/features/auth/data/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart'
    hide User, AuthException;
import '../../../../core/database/database_repository.dart';
import '../../../../core/database/supabase_client.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository_interface.dart';

class AuthRepository extends DatabaseRepository
    implements AuthRepositoryInterface {
  final SupabaseClient _supabaseClient = SupabaseClientService.client;

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw AppAuthException('Usuario no encontrado');
      }

      final userData = await fetchById(
        table: DatabaseTables.usuarios,
        id: authResponse.user!.id,
      );

      return UserEntity.fromJson(userData);
    } on AppAuthException {
      rethrow;
    } catch (e) {
      throw AppAuthException('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (authResponse.user == null) {
        throw AppAuthException('Error al crear usuario');
      }

      // Crear registro en tabla usuarios con onboarding_completado = false
      final userData = await insert(
        table: DatabaseTables.usuarios,
        data: {
          'id': authResponse.user!.id,
          'username': _generateTemporaryUsername(email),
          'email': email,
          'pais': null,
          'ciudad': null,
          'rol': 'customer',
          'onboarding_completado': false,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      return UserEntity.fromJson(userData);
    } catch (e) {
      throw AppAuthException('Error al registrarse: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw AppAuthException('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return null;

      final userData = await fetchById(
        table: DatabaseTables.usuarios,
        id: session.user.id,
      );

      return UserEntity.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((state) async {
      if (state.session == null) return null;

      try {
        final userData = await fetchById(
          table: DatabaseTables.usuarios,
          id: state.session!.user.id,
        );

        return UserEntity.fromJson(userData);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserEntity> updateUserProfile({
    required String userId,
    required String username,
    required String pais,
    required String ciudad,
  }) async {
    try {
      // Verificar que el username no exista
      final existingUser = await _supabaseClient
          .from(DatabaseTables.usuarios)
          .select('id')
          .eq('username', username)
          .neq('id', userId)
          .maybeSingle();

      if (existingUser != null) {
        throw AppAuthException(
          'El nombre de usuario ya está en uso',
        );
      }

      // Actualizar perfil del usuario
      final userData = await update(
        table: DatabaseTables.usuarios,
        id: userId,
        data: {
          'username': username,
          'pais': pais,
          'ciudad': ciudad,
          'onboarding_completado': true,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      return UserEntity.fromJson(userData);
    } catch (e) {
      if (e is AppAuthException) rethrow;
      throw AppAuthException('Error al actualizar perfil: $e');
    }
  }

  // Generar username temporal basado en email
  String _generateTemporaryUsername(String email) {
    final emailPrefix = email.split('@').first;
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(8);
    return '${emailPrefix}_$timestamp';
  }
}
