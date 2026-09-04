// lib/features/business/domain/entities/negocio_completo.dart
import 'negocio.dart';
import 'sucursal.dart';
import 'usuario_negocio.dart';
import '../../../product/domain/entities/producto.dart';

class NegocioCompleto {
  final Negocio negocio;
  final List<Sucursal> sucursales;
  final List<UsuarioNegocio> usuarios;
  final List<Producto> productos;

  NegocioCompleto({
    required this.negocio,
    required this.sucursales,
    required this.usuarios,
    required this.productos,
  });

  factory NegocioCompleto.fromJson(Map<String, dynamic> json) {
    return NegocioCompleto(
      negocio: Negocio.fromJson(json['negocio'] as Map<String, dynamic>),
      sucursales: (json['sucursales'] as List<dynamic>? ?? [])
          .map((e) => Sucursal.fromJson(e as Map<String, dynamic>))
          .toList(),
      usuarios: (json['usuarios'] as List<dynamic>? ?? [])
          .map((e) => UsuarioNegocio.fromJson(e as Map<String, dynamic>))
          .toList(),
      productos: (json['productos'] as List<dynamic>? ?? [])
          .map((e) => Producto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}