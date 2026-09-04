// lib/features/business/domain/repositories/sucursal_repository_interface.dart
import '../entities/sucursal.dart';

abstract class SucursalRepositoryInterface {
  Future<Sucursal> createSucursal({
    required String idNegocio,
    required String direccion,
    double? latitud,
    double? longitud,
    String? celular,
  });
  
  Future<Sucursal> getSucursalById(String id);
  
  Future<List<Sucursal>> getSucursalesByNegocio(String idNegocio);
  
  Future<Sucursal> updateSucursal({
    required String id,
    String? direccion,
    double? latitud,
    double? longitud,
    String? celular,
    bool? activo,
  });
  
  Future<void> deleteSucursal(String id);
  
  // Método combinado para registrar negocio y sucursal
  Future<Map<String, dynamic>> registerBusinessWithSucursal({
    required String userId,
    required String nombreNegocio,
    String? descripcionNegocio,
    String? celularNegocio,
    String? imagenNegocio,
    required String direccionSucursal,
    double? latitudSucursal,
    double? longitudSucursal,
    String? celularSucursal,
  });
}