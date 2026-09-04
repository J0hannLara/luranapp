// lib/features/home/presentation/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:luranapp/features/product/domain/entities/producto.dart';
import 'package:luranapp/features/offer/domain/entities/oferta.dart';
import 'package:luranapp/features/product/domain/repositories/product_repository_interface.dart';
import 'package:luranapp/features/offer/domain/repositories/offer_repository_interface.dart';
import 'package:luranapp/core/utils/view_state.dart';

class HomeController extends GetxController with ViewStateMixin {
  final ProductRepositoryInterface _productRepository;
  final OfferRepositoryInterface _offerRepository;

  HomeController(this._productRepository, this._offerRepository);

  // Listas de ofertas
  final RxList<Oferta> nearbyOffers = <Oferta>[].obs;
  final RxList<Oferta> endingSoon = <Oferta>[].obs;
  final RxList<Oferta> biggestDiscounts = <Oferta>[].obs;
  final RxList<Oferta> nearbyBusinesses = <Oferta>[].obs;

  // Mapa de productos por ID para mostrar información
  final RxMap<String, Producto> productosMap = <String, Producto>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadOfertas();
  }

  // Método para obtener producto por ID
  Producto? getProductoById(String productoId) {
    return productosMap[productoId];
  }

  Future<void> loadOfertas() async {
    try {
      setLoading();
      setError('');

      // Cargar todos los productos primero
      final productos = await _productRepository.getAllProducts();
      productosMap.value = {for (var p in productos) p.id: p};

      final ofertas = await _offerRepository.getAllOffers();

      // Distribuir todas las ofertas en las secciones (sin filtrar)
      _distributeOffers(ofertas);

      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  void _distributeOffers(List<Oferta> ofertas) {
    if (ofertas.isEmpty) {
      nearbyOffers.clear();
      endingSoon.clear();
      biggestDiscounts.clear();
      nearbyBusinesses.clear();
      return;
    }

    // Ofertas cerca de ti: primeras 5
    nearbyOffers.value = ofertas.take(5).toList();

    // Terminan pronto: ordenar por fecha_fin si existe
    final endingSoonList = List<Oferta>.from(ofertas)
      ..sort((a, b) {
        if (a.fechaFin == null) return 1;
        if (b.fechaFin == null) return -1;
        return a.fechaFin!.compareTo(b.fechaFin!);
      });
    endingSoon.value = endingSoonList.take(5).toList();

    // Mayores descuentos: ordenar por porcentaje_descuento
    final discountsList = List<Oferta>.from(ofertas)
      ..sort((a, b) {
        final descA = a.porcentajeDescuento ?? 0;
        final descB = b.porcentajeDescuento ?? 0;
        return descB.compareTo(descA);
      });
    biggestDiscounts.value = discountsList.take(5).toList();

    // Negocios cercanos: mezclar
    final businessList = List<Oferta>.from(ofertas)..shuffle();
    nearbyBusinesses.value = businessList.take(5).toList();
  }
}
