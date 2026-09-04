// lib/features/offer/domain/entities/oferta.dart
class Oferta {
  final String id;
  final String idSucursal;
  final String idProducto;
  final double precioRegular;
  final double precioRemate;
  final int stock;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String estado;
  final double? porcentajeDescuento;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Oferta({
    required this.id,
    required this.idSucursal,
    required this.idProducto,
    required this.precioRegular,
    required this.precioRemate,
    required this.stock,
    this.fechaInicio,
    this.fechaFin,
    this.estado = 'borrador',
    this.porcentajeDescuento,
    this.createdAt,
    this.updatedAt,
  });

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: json['id'] as String,
      idSucursal: json['id_sucursal'] as String,
      idProducto: json['id_producto'] as String,
      precioRegular: double.parse(json['precio_regular'].toString()),
      precioRemate: double.parse(json['precio_remate'].toString()),
      stock: json['stock'] as int,
      fechaInicio: json['fecha_inicio'] != null 
          ? DateTime.parse(json['fecha_inicio'] as String) 
          : null,
      fechaFin: json['fecha_fin'] != null 
          ? DateTime.parse(json['fecha_fin'] as String) 
          : null,
      estado: json['estado'] as String? ?? 'borrador',
      porcentajeDescuento: json['porcentaje_descuento'] != null 
          ? double.parse(json['porcentaje_descuento'].toString()) 
          : null,
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
      'id_sucursal': idSucursal,
      'id_producto': idProducto,
      'precio_regular': precioRegular,
      'precio_remate': precioRemate,
      'stock': stock,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'estado': estado,
      'porcentaje_descuento': porcentajeDescuento,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}