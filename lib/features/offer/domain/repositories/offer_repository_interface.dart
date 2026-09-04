// lib/features/offer/domain/repositories/offer_repository_interface.dart
import '../entities/oferta.dart';

abstract class OfferRepositoryInterface {
  Future<Oferta> createOffer({
    required String idSucursal,
    required String idProducto,
    required double precioRegular,
    required double precioRemate,
    required int stock,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String estado = 'borrador',
  });

  Future<Oferta> getOfferById(String id);

  Future<List<Oferta>> getOffersBySucursal(String idSucursal);

  Future<List<Oferta>> getOffersByProducto(String idProducto);

  Future<List<Oferta>> getAllOffers();

  Future<Oferta> updateOffer({
    required String id,
    double? precioRegular,
    double? precioRemate,
    int? stock,
    DateTime? fechaFin,
    String? estado,
  });

  Future<void> deleteOffer(String id);
}
