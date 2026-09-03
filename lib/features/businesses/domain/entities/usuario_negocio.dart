// lib/features/business/domain/entities/usuario_negocio.dart
import 'rol_negocio.dart';

/// Entidad que representa la relación entre un usuario y un negocio
class UsuarioNegocio {
  final String id;
  final String idUsuario;
  final String idNegocio;
  final RolNegocio rol;
  final DateTime? createdAt;

  UsuarioNegocio({
    required this.id,
    required this.idUsuario,
    required this.idNegocio,
    this.rol = RolNegocio.propietario,
    this.createdAt,
  });

  factory UsuarioNegocio.fromJson(Map<String, dynamic> json) {
    return UsuarioNegocio(
      id: json['id'] as String,
      idUsuario: json['id_usuario'] as String,
      idNegocio: json['id_negocio'] as String,
      rol: RolNegocio.fromString(json['rol'] as String?),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'id_negocio': idNegocio,
      'rol': rol.value,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UsuarioNegocio copyWith({
    String? idUsuario,
    String? idNegocio,
    RolNegocio? rol,
  }) {
    return UsuarioNegocio(
      id: id,
      idUsuario: idUsuario ?? this.idUsuario,
      idNegocio: idNegocio ?? this.idNegocio,
      rol: rol ?? this.rol,
      createdAt: createdAt,
    );
  }

  // Helpers para verificar roles
  bool get isPropietario => rol == RolNegocio.propietario;
  bool get isAdministrador => rol == RolNegocio.administrador;
  bool get isEmpleado => rol == RolNegocio.empleado;

  // Helper para obtener etiqueta legible del rol
  String get rolLabel => rol.label;

  @override
  String toString() {
    return 'UsuarioNegocio(id: $id, idUsuario: $idUsuario, idNegocio: $idNegocio, rol: ${rol.value})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UsuarioNegocio &&
        other.id == id &&
        other.idUsuario == idUsuario &&
        other.idNegocio == idNegocio &&
        other.rol == rol;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idUsuario.hashCode ^
        idNegocio.hashCode ^
        rol.hashCode;
  }
}