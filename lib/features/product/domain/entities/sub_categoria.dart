// lib/features/product/domain/entities/sub_categoria.dart
class SubCategoria {
  final String id;
  final String idCategoria;
  final String nombre;
  final String? descripcion;
  final String? icono;

  SubCategoria({
    required this.id,
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
    this.icono,
  });

  factory SubCategoria.fromJson(Map<String, dynamic> json) {
    return SubCategoria(
      id: json['id'] as String,
      idCategoria: json['id_categoria'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      icono: json['icono'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
    };
  }
}