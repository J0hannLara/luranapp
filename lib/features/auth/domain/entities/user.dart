// lib/features/auth/domain/entities/user.dart
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? pais;
  final String? ciudad;
  final String rol;
  final bool onboardingCompletado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.pais,
    this.ciudad,
    this.rol = 'customer',
    this.onboardingCompletado = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      pais: json['pais'] as String?,
      ciudad: json['ciudad'] as String?,
      rol: json['rol'] as String? ?? 'customer',
      onboardingCompletado: json['onboarding_completado'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'pais': pais,
      'ciudad': ciudad,
      'rol': rol,
      'onboarding_completado': onboardingCompletado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  // Helper para verificar si necesita completar onboarding
  bool get needsOnboarding => !onboardingCompletado;
  
  // Helper para verificar si es negocio
  bool get isBusiness => rol == 'business';
  
  // Helper para verificar si es cliente
  bool get isCustomer => rol == 'customer';
}