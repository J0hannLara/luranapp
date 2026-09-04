// lib/features/product/domain/entities/categoria.dart
class Categoria {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? icono;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      icono: json['icono'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
    };
  }
}