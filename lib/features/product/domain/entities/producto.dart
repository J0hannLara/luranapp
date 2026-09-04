// lib/features/product/domain/entities/producto.dart
class Producto {
  final String id;
  final String idSubCategoria;
  final String nombre;
  final String? descripcion;
  final String? imagen;
  final DateTime? createdAt;

  Producto({
    required this.id,
    required this.idSubCategoria,
    required this.nombre,
    this.descripcion,
    this.imagen,
    this.createdAt,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      idSubCategoria: json['id_sub_categoria'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      imagen: json['imagen'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sub_categoria': idSubCategoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Producto copyWith({
    String? idSubCategoria,
    String? nombre,
    String? descripcion,
    String? imagen,
  }) {
    return Producto(
      id: id,
      idSubCategoria: idSubCategoria ?? this.idSubCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      createdAt: createdAt,
    );
  }
}