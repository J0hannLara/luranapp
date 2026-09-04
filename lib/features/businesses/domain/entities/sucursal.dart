// lib/features/business/domain/entities/sucursal.dart
class Sucursal {
  final String id;
  final String idNegocio;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final String? celular;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Sucursal({
    required this.id,
    required this.idNegocio,
    required this.direccion,
    this.latitud,
    this.longitud,
    this.celular,
    this.activo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as String,
      idNegocio: json['id_negocio'] as String,
      direccion: json['direccion'] as String,
      latitud: json['latitud'] != null 
          ? double.parse(json['latitud'].toString()) 
          : null,
      longitud: json['longitud'] != null 
          ? double.parse(json['longitud'].toString()) 
          : null,
      celular: json['celular'] as String?,
      activo: json['activo'] as bool? ?? true,
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
      'id_negocio': idNegocio,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
      'celular': celular,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Sucursal copyWith({
    String? direccion,
    double? latitud,
    double? longitud,
    String? celular,
    bool? activo,
  }) {
    return Sucursal(
      id: id,
      idNegocio: idNegocio,
      direccion: direccion ?? this.direccion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      celular: celular ?? this.celular,
      activo: activo ?? this.activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}