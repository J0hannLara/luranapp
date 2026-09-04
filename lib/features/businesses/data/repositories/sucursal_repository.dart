// lib/features/business/data/repositories/sucursal_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/database_repository.dart';
import '../../../../core/database/supabase_client.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/sucursal.dart';
import '../../domain/repositories/sucursal_repository_interface.dart';
import '../../domain/repositories/business_repository_interface.dart';

class SucursalRepository extends DatabaseRepository implements SucursalRepositoryInterface {
  final SupabaseClient _client = SupabaseClientService.client;
  final BusinessRepositoryInterface _businessRepository;
  
  SucursalRepository(this._businessRepository);
  
  @override
  Future<Sucursal> createSucursal({
    required String idNegocio,
    required String direccion,
    double? latitud,
    double? longitud,
    String? celular,
  }) async {
    try {
      final sucursalData = await insert(
        table: DatabaseTables.sucursales,
        data: {
          'id_negocio': idNegocio,
          'direccion': direccion,
          'latitud': latitud,
          'longitud': longitud,
          'celular': celular,
          'activo': true,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      return Sucursal.fromJson(sucursalData);
    } catch (e) {
      throw DatabaseException('Error al crear sucursal: $e');
    }
  }
  
  @override
  Future<Sucursal> getSucursalById(String id) async {
    try {
      final sucursalData = await fetchById(
        table: DatabaseTables.sucursales,
        id: id,
      );
      
      return Sucursal.fromJson(sucursalData);
    } catch (e) {
      throw DatabaseException('Error al obtener sucursal: $e');
    }
  }
  
  @override
  Future<List<Sucursal>> getSucursalesByNegocio(String idNegocio) async {
    try {
      final response = await _client
          .from(DatabaseTables.sucursales)
          .select()
          .eq('id_negocio', idNegocio)
          .order('created_at');
      
      return response
          .map((data) => Sucursal.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener sucursales: $e');
    }
  }
  
  @override
  Future<Sucursal> updateSucursal({
    required String id,
    String? direccion,
    double? latitud,
    double? longitud,
    String? celular,
    bool? activo,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (direccion != null) updateData['direccion'] = direccion;
      if (latitud != null) updateData['latitud'] = latitud;
      if (longitud != null) updateData['longitud'] = longitud;
      if (celular != null) updateData['celular'] = celular;
      if (activo != null) updateData['activo'] = activo;
      
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      final sucursalData = await update(
        table: DatabaseTables.sucursales,
        id: id,
        data: updateData,
      );
      
      return Sucursal.fromJson(sucursalData);
    } catch (e) {
      throw DatabaseException('Error al actualizar sucursal: $e');
    }
  }
  
  @override
  Future<void> deleteSucursal(String id) async {
    try {
      await delete(
        table: DatabaseTables.sucursales,
        id: id,
      );
    } catch (e) {
      throw DatabaseException('Error al eliminar sucursal: $e');
    }
  }
  
  @override
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
  }) async {
    try {
      // 1. Crear el negocio
      final negocio = await _businessRepository.registerBusiness(
        userId: userId,
        nombre: nombreNegocio,
        descripcion: descripcionNegocio,
        celular: celularNegocio,
        imagen: imagenNegocio,
      );
      
      // 2. Crear la sucursal
      final sucursal = await createSucursal(
        idNegocio: negocio.id,
        direccion: direccionSucursal,
        latitud: latitudSucursal,
        longitud: longitudSucursal,
        celular: celularSucursal,
      );
      
      return {
        'negocio': negocio,
        'sucursal': sucursal,
      };
    } catch (e) {
      throw DatabaseException('Error al registrar negocio con sucursal: $e');
    }
  }
}