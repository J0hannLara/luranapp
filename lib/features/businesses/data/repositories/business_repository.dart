// lib/features/business/data/repositories/business_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/database_repository.dart';
import '../../../../core/database/supabase_client.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/negocio.dart';
import '../../domain/entities/usuario_negocio.dart';
import '../../domain/repositories/business_repository_interface.dart';

class BusinessRepository extends DatabaseRepository implements BusinessRepositoryInterface {
  final SupabaseClient _client = SupabaseClientService.client;
  
  @override
  Future<Negocio> createBusiness({
    required String nombre,
    String? descripcion,
    String? celular,
    String? imagen,
  }) async {
    try {
      final businessData = await insert(
        table: DatabaseTables.negocios,
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'celular': celular,
          'imagen': imagen,
          'estado': 'pendiente',
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      return Negocio.fromJson(businessData);
    } catch (e) {
      throw DatabaseException('Error al crear negocio: $e');
    }
  }
  
  @override
  Future<Negocio> getBusinessById(String id) async {
    try {
      final businessData = await fetchById(
        table: DatabaseTables.negocios,
        id: id,
      );
      
      return Negocio.fromJson(businessData);
    } catch (e) {
      throw DatabaseException('Error al obtener negocio: $e');
    }
  }
  
  @override
  Future<List<Negocio>> getBusinessesByUser(String userId) async {
    try {
      final response = await _client
          .from(DatabaseTables.usuariosNegocios)
          .select('''
            id_negocio,
            negocios:negocios(*)
          ''')
          .eq('id_usuario', userId);
      
      final businesses = response
          .map((data) => Negocio.fromJson(data['negocios'] as Map<String, dynamic>))
          .toList();
      
      return businesses;
    } catch (e) {
      throw DatabaseException('Error al obtener negocios del usuario: $e');
    }
  }
  
  @override
  Future<Negocio> updateBusiness({
    required String id,
    String? nombre,
    String? descripcion,
    String? celular,
    String? imagen,
    String? estado,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (nombre != null) updateData['nombre'] = nombre;
      if (descripcion != null) updateData['descripcion'] = descripcion;
      if (celular != null) updateData['celular'] = celular;
      if (imagen != null) updateData['imagen'] = imagen;
      if (estado != null) updateData['estado'] = estado;
      
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      final businessData = await update(
        table: DatabaseTables.negocios,
        id: id,
        data: updateData,
      );
      
      return Negocio.fromJson(businessData);
    } catch (e) {
      throw DatabaseException('Error al actualizar negocio: $e');
    }
  }
  
  @override
  Future<void> deleteBusiness(String id) async {
    try {
      await delete(
        table: DatabaseTables.negocios,
        id: id,
      );
    } catch (e) {
      throw DatabaseException('Error al eliminar negocio: $e');
    }
  }
  
  @override
  Future<UsuarioNegocio> assignUserToBusiness({
    required String userId,
    required String businessId,
    String rol = 'propietario',
  }) async {
    try {
      final relationData = await insert(
        table: DatabaseTables.usuariosNegocios,
        data: {
          'id_usuario': userId,
          'id_negocio': businessId,
          'rol': rol,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      return UsuarioNegocio.fromJson(relationData);
    } catch (e) {
      throw DatabaseException('Error al asignar usuario al negocio: $e');
    }
  }
  
  @override
  Future<List<UsuarioNegocio>> getBusinessUsers(String businessId) async {
    try {
      final response = await _client
          .from(DatabaseTables.usuariosNegocios)
          .select()
          .eq('id_negocio', businessId);
      
      return response
          .map((data) => UsuarioNegocio.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener usuarios del negocio: $e');
    }
  }
  
  @override
  Future<void> removeUserFromBusiness({
    required String userId,
    required String businessId,
  }) async {
    try {
      await _client
          .from(DatabaseTables.usuariosNegocios)
          .delete()
          .eq('id_usuario', userId)
          .eq('id_negocio', businessId);
    } catch (e) {
      throw DatabaseException('Error al eliminar usuario del negocio: $e');
    }
  }
  
  @override
  Future<Negocio> registerBusiness({
    required String userId,
    required String nombre,
    String? descripcion,
    String? celular,
    String? imagen,
  }) async {
    try {
      // Usar la función RPC crear_negocio
      // Esta función crea el negocio y automáticamente asigna al usuario como propietario
      final response = await _client.rpc('crear_negocio', params: {
        'p_nombre': nombre,
        'p_descripcion': descripcion,
        'p_celular': celular,
        'p_imagen': imagen,
      });
      
      if (response == null) {
        throw DatabaseException('No se pudo crear el negocio');
      }
      
      // La respuesta puede ser un Map o una List con un Map
      final businessData = response is List 
          ? response.first as Map<String, dynamic>
          : response as Map<String, dynamic>;
      
      return Negocio.fromJson(businessData);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Error al registrar negocio: $e');
    }
  }
  
  /// Método para verificar el estado de un negocio
  Future<String> getBusinessStatus(String businessId) async {
    try {
      final response = await _client
          .from(DatabaseTables.negocios)
          .select('estado')
          .eq('id', businessId)
          .single();
      
      return response['estado'] as String;
    } catch (e) {
      throw DatabaseException('Error al obtener estado del negocio: $e');
    }
  }
  
  /// Método para obtener negocios pendientes de aprobación (para admin)
  Future<List<Negocio>> getPendingBusinesses() async {
    try {
      final response = await _client
          .from(DatabaseTables.negocios)
          .select()
          .eq('estado', 'pendiente')
          .order('created_at', ascending: true);
      
      return response
          .map((data) => Negocio.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener negocios pendientes: $e');
    }
  }
}