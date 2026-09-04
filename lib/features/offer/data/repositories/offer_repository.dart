// lib/features/offer/data/repositories/offer_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/database_repository.dart';
import '../../../../core/database/supabase_client.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/oferta.dart';
import '../../domain/repositories/offer_repository_interface.dart';

class OfferRepository extends DatabaseRepository
    implements OfferRepositoryInterface {
  final SupabaseClient _client = SupabaseClientService.client;

  @override
  Future<Oferta> createOffer({
    required String idSucursal,
    required String idProducto,
    required double precioRegular,
    required double precioRemate,
    required int stock,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String estado = 'borrador',
  }) async {
    try {
      // Validar que el precio de remate sea menor al regular
      if (precioRemate >= precioRegular) {
        throw DatabaseException(
          'El precio de remate debe ser menor al precio regular',
        );
      }

      final offerData = await insert(
        table: DatabaseTables.sucursalesProductos,
        data: {
          'id_sucursal': idSucursal,
          'id_producto': idProducto,
          'precio_regular': precioRegular,
          'precio_remate': precioRemate,
          'stock': stock,
          'fecha_inicio':
              fechaInicio?.toIso8601String() ??
              DateTime.now().toIso8601String(),
          'fecha_fin': fechaFin?.toIso8601String(),
          'estado': estado,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      return Oferta.fromJson(offerData);
    } catch (e) {
      throw DatabaseException('Error al crear oferta: $e');
    }
  }

  @override
  Future<List<Oferta>> getAllOffers() async {
    try {
      final response = await _client
          .from(DatabaseTables.sucursalesProductos)
          .select()
          .order('created_at', ascending: false);

      return response.map((data) => Oferta.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ofertas: $e');
    }
  }

  @override
  Future<Oferta> getOfferById(String id) async {
    try {
      final offerData = await fetchById(
        table: DatabaseTables.sucursalesProductos,
        id: id,
      );

      return Oferta.fromJson(offerData);
    } catch (e) {
      throw DatabaseException('Error al obtener oferta: $e');
    }
  }

  @override
  Future<List<Oferta>> getOffersBySucursal(String idSucursal) async {
    try {
      final response = await _client
          .from(DatabaseTables.sucursalesProductos)
          .select()
          .eq('id_sucursal', idSucursal)
          .order('created_at', ascending: false);

      return response.map((data) => Oferta.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ofertas por sucursal: $e');
    }
  }

  @override
  Future<List<Oferta>> getOffersByProducto(String idProducto) async {
    try {
      final response = await _client
          .from(DatabaseTables.sucursalesProductos)
          .select()
          .eq('id_producto', idProducto)
          .order('created_at', ascending: false);

      return response.map((data) => Oferta.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ofertas por producto: $e');
    }
  }

  @override
  Future<Oferta> updateOffer({
    required String id,
    double? precioRegular,
    double? precioRemate,
    int? stock,
    DateTime? fechaFin,
    String? estado,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (precioRegular != null) updateData['precio_regular'] = precioRegular;
      if (precioRemate != null) updateData['precio_remate'] = precioRemate;
      if (stock != null) updateData['stock'] = stock;
      if (fechaFin != null)
        updateData['fecha_fin'] = fechaFin.toIso8601String();
      if (estado != null) updateData['estado'] = estado;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      final offerData = await update(
        table: DatabaseTables.sucursalesProductos,
        id: id,
        data: updateData,
      );

      return Oferta.fromJson(offerData);
    } catch (e) {
      throw DatabaseException('Error al actualizar oferta: $e');
    }
  }

  @override
  Future<void> deleteOffer(String id) async {
    try {
      await delete(table: DatabaseTables.sucursalesProductos, id: id);
    } catch (e) {
      throw DatabaseException('Error al eliminar oferta: $e');
    }
  }
}
