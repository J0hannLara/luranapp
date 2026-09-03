// lib/features/business/domain/repositories/business_repository_interface.dart
import '../entities/negocio.dart';
import '../entities/usuario_negocio.dart';

abstract class BusinessRepositoryInterface {
  // CRUD de negocios
  Future<Negocio> createBusiness({
    required String nombre,
    String? descripcion,
    String? celular,
    String? imagen,
  });
  
  Future<Negocio> getBusinessById(String id);
  
  Future<List<Negocio>> getBusinessesByUser(String userId);
  
  Future<Negocio> updateBusiness({
    required String id,
    String? nombre,
    String? descripcion,
    String? celular,
    String? imagen,
    String? estado,
  });
  
  Future<void> deleteBusiness(String id);
  
  // Relación usuario-negocio
  Future<UsuarioNegocio> assignUserToBusiness({
    required String userId,
    required String businessId,
    String rol = 'propietario',
  });
  
  Future<List<UsuarioNegocio>> getBusinessUsers(String businessId);
  
  Future<void> removeUserFromBusiness({
    required String userId,
    required String businessId,
  });
  
  // Método combinado para crear negocio y asignar usuario
  Future<Negocio> registerBusiness({
    required String userId,
    required String nombre,
    String? descripcion,
    String? celular,
    String? imagen,
  });
}