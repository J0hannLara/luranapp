// lib/features/offer/presentation/controllers/add_offer_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../product/domain/entities/producto.dart';
import '../../../product/domain/entities/categoria.dart';
import '../../../product/domain/entities/sub_categoria.dart';
import '../../../product/domain/repositories/product_repository_interface.dart';
import '../../../businesses/domain/entities/sucursal.dart';
import '../../../businesses/domain/repositories/business_repository_interface.dart';
import '../../domain/entities/oferta.dart';
import '../../domain/repositories/offer_repository_interface.dart';
import '../../../../core/utils/view_state.dart';

class AddOfferController extends GetxController with ViewStateMixin {
  final ProductRepositoryInterface _productRepository;
  final BusinessRepositoryInterface _businessRepository;
  final OfferRepositoryInterface _offerRepository;
  final String businessId;

  AddOfferController(
    this._productRepository,
    this._businessRepository,
    this._offerRepository,
    this.businessId,
  );

  // Controllers para formulario
  final TextEditingController precioRegularController = TextEditingController();
  final TextEditingController precioRemateController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  // Estado
  final RxList<Categoria> categorias = <Categoria>[].obs;
  final RxList<SubCategoria> subCategorias = <SubCategoria>[].obs;
  final RxList<Producto> productos = <Producto>[].obs;
  final RxList<Sucursal> sucursales = <Sucursal>[].obs;
  final RxList<String> sucursalesSeleccionadas = <String>[].obs;

  final Rx<Categoria?> selectedCategoria = Rx<Categoria?>(null);
  final Rx<SubCategoria?> selectedSubCategoria = Rx<SubCategoria?>(null);
  final Rx<Producto?> selectedProducto = Rx<Producto?>(null);

  final RxBool isLoadingCategorias = false.obs;
  final RxBool isLoadingSubCategorias = false.obs;
  final RxBool isLoadingProductos = false.obs;
  final RxBool isLoadingSucursales = false.obs;
  final RxBool isSubmitting = false.obs;

  // Getters
  bool get canContinue {
    return selectedProducto.value != null;
  }

  bool get canSubmit {
    return selectedProducto.value != null &&
        sucursalesSeleccionadas.isNotEmpty &&
        _isValidPrecioRegular() &&
        _isValidPrecioRemate() &&
        _isValidStock();
  }

  double? get precioRegular => double.tryParse(precioRegularController.text);
  double? get precioRemate => double.tryParse(precioRemateController.text);
  int? get stock => int.tryParse(stockController.text);

  double? get porcentajeDescuento {
    if (precioRegular != null && precioRemate != null && precioRegular! > 0) {
      return ((precioRegular! - precioRemate!) / precioRegular!) * 100;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    _setupListeners();
  }

  @override
  void onClose() {
    precioRegularController.dispose();
    precioRemateController.dispose();
    stockController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    precioRegularController.addListener(_updateSubmitState);
    precioRemateController.addListener(_updateSubmitState);
    stockController.addListener(_updateSubmitState);
  }

  void _updateSubmitState() {
    update(['offer_form']);
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadCategorias(), loadSucursales()]);
  }

  Future<void> loadCategorias() async {
    try {
      isLoadingCategorias.value = true;
      categorias.value = await _productRepository.getAllCategorias();
    } catch (e) {
      setError(e.toString());
    } finally {
      isLoadingCategorias.value = false;
    }
  }

  void toggleSucursal(String sucursalId) {
    if (sucursalesSeleccionadas.contains(sucursalId)) {
      sucursalesSeleccionadas.remove(sucursalId);
    } else {
      sucursalesSeleccionadas.add(sucursalId);
    }
    _updateSubmitState();
  }


  Future<void> loadSubCategorias(String idCategoria) async {
    try {
      isLoadingSubCategorias.value = true;
      subCategorias.value = await _productRepository
          .getSubCategoriasByCategoria(idCategoria);
      productos.clear();
      selectedSubCategoria.value = null;
      selectedProducto.value = null;
    } catch (e) {
      setError(e.toString());
    } finally {
      isLoadingSubCategorias.value = false;
    }
  }

  Future<void> loadProductos(String idSubCategoria) async {
    try {
      isLoadingProductos.value = true;
      productos.value = await _productRepository.getProductsBySubCategoria(
        idSubCategoria,
      );
      selectedProducto.value = null;
    } catch (e) {
      setError(e.toString());
    } finally {
      isLoadingProductos.value = false;
    }
  }

  Future<void> loadSucursales() async {
    try {
      isLoadingSucursales.value = true;

      final negocioCompleto = await _businessRepository.getBusinessComplete(
        businessId,
      );
      sucursales.value = negocioCompleto.sucursales
          .where((s) => s.activo)
          .toList();
    } catch (e) {
      setError(e.toString());
    } finally {
      isLoadingSucursales.value = false;
    }
  }

  void selectCategoria(Categoria? categoria) {
    selectedCategoria.value = categoria;
    subCategorias.clear();
    productos.clear();
    selectedSubCategoria.value = null;
    selectedProducto.value = null;

    if (categoria != null) {
      loadSubCategorias(categoria.id);
    }
  }

  void selectSubCategoria(SubCategoria? subCategoria) {
    selectedSubCategoria.value = subCategoria;
    productos.clear();
    selectedProducto.value = null;

    if (subCategoria != null) {
      loadProductos(subCategoria.id);
    }
  }

  void selectProducto(Producto? producto) {
    selectedProducto.value = producto;
    update(['product_selection']);
  }

  bool isSucursalSelected(String sucursalId) {
    return sucursalesSeleccionadas.contains(sucursalId);
  }

  bool _isValidPrecioRegular() {
    final precio = precioRegular;
    return precio != null && precio > 0;
  }

  bool _isValidPrecioRemate() {
    final regular = precioRegular;
    final remate = precioRemate;
    return remate != null && remate > 0 && regular != null && remate < regular;
  }

  bool _isValidStock() {
    final stockValue = stock;
    return stockValue != null && stockValue >= 0;
  }

  Future<void> createOfertas() async {
    if (!canSubmit) {
      setError('Por favor completa todos los campos correctamente');
      return;
    }

    try {
      setLoading();
      isSubmitting.value = true;
      setError('');

      final ofertasCreadas = <Oferta>[];

      // Crear oferta para cada sucursal seleccionada
      for (final sucursalId in sucursalesSeleccionadas) {
        final oferta = await _offerRepository.createOffer(
          idSucursal: sucursalId,
          idProducto: selectedProducto.value!.id,
          precioRegular: precioRegular!,
          precioRemate: precioRemate!,
          stock: stock!,
          estado: 'borrador',
        );
        ofertasCreadas.add(oferta);
      }

      setSuccess(
        message: '${ofertasCreadas.length} oferta(s) creada(s) exitosamente',
      );

      // Limpiar formulario
      _clearForm();

      // Navegar de vuelta al dashboard
      Get.back();

      Get.snackbar(
        'Éxito',
        'Ofertas creadas exitosamente',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void _clearForm() {
    precioRegularController.clear();
    precioRemateController.clear();
    stockController.clear();
    sucursalesSeleccionadas.clear();
    selectedProducto.value = null;
    selectedCategoria.value = null;
    selectedSubCategoria.value = null;
    productos.clear();
    subCategorias.clear();
  }
}
