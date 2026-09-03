// lib/features/business/domain/entities/negocio.dart
class Negocio {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? celular;
  final String? imagen;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Negocio({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.celular,
    this.imagen,
    this.estado = 'pendiente',
    this.createdAt,
    this.updatedAt,
  });

  factory Negocio.fromJson(Map<String, dynamic> json) {
    return Negocio(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      celular: json['celular'] as String?,
      imagen: json['imagen'] as String?,
      estado: json['estado'] as String? ?? 'pendiente',
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
      'nombre': nombre,
      'descripcion': descripcion,
      'celular': celular,
      'imagen': imagen,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  Negocio copyWith({
    String? nombre,
    String? descripcion,
    String? celular,
    String? imagen,
    String? estado,
  }) {
    return Negocio(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      celular: celular ?? this.celular,
      imagen: imagen ?? this.imagen,
      estado: estado ?? this.estado,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
