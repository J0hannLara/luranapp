// lib/features/product/presentation/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/producto.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/sub_categoria.dart';
import '../../domain/repositories/product_repository_interface.dart';
import '../../../../core/utils/view_state.dart';

class ProductController extends GetxController with ViewStateMixin {
  final ProductRepositoryInterface _productRepository;
  
  ProductController(this._productRepository);
  
  // Controllers para formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  
  // Estado
  final RxList<Producto> productos = <Producto>[].obs;
  final RxList<Categoria> categorias = <Categoria>[].obs;
  final RxList<SubCategoria> subCategorias = <SubCategoria>[].obs;
  final RxList<SubCategoria> allSubCategorias = <SubCategoria>[].obs;
  final Rx<Categoria?> selectedCategoria = Rx<Categoria?>(null);
  final Rx<SubCategoria?> selectedSubCategoria = Rx<SubCategoria?>(null);
  final RxString searchQuery = ''.obs;
  
  // Getters
  List<Producto> get filteredProductos {
    if (searchQuery.value.isEmpty) return productos;
    
    return productos
        .where((p) => p.nombre.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
  
  bool get canSubmit {
    return nombreController.text.trim().isNotEmpty &&
           selectedSubCategoria.value != null;
  }
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  @override
  void onClose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.onClose();
  }
  
  Future<void> loadInitialData() async {
    await Future.wait([
      loadCategorias(),
      loadAllSubCategorias(),
      loadProductos(),
    ]);
  }
  
  Future<void> loadCategorias() async {
    try {
      categorias.value = await _productRepository.getAllCategorias();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> loadAllSubCategorias() async {
    try {
      allSubCategorias.value = await _productRepository.getAllSubCategorias();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> loadSubCategorias(String idCategoria) async {
    try {
      setLoading();
      subCategorias.value = await _productRepository.getSubCategoriasByCategoria(idCategoria);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> loadProductos() async {
    try {
      setLoading();
      productos.value = await _productRepository.getAllProducts();
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  void selectCategoria(Categoria? categoria) {
    selectedCategoria.value = categoria;
    selectedSubCategoria.value = null;
    subCategorias.clear();
    
    if (categoria != null) {
      loadSubCategorias(categoria.id);
    }
  }
  
  void selectSubCategoria(SubCategoria? subCategoria) {
    selectedSubCategoria.value = subCategoria;
  }
  
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
  
  Future<void> createProduct() async {
    if (!canSubmit) {
      setError('Por favor completa todos los campos');
      return;
    }
    
    try {
      setLoading();
      
      final producto = await _productRepository.createProduct(
        idSubCategoria: selectedSubCategoria.value!.id,
        nombre: nombreController.text.trim(),
        descripcion: descripcionController.text.trim().isEmpty 
            ? null 
            : descripcionController.text.trim(),
      );
      
      productos.add(producto);
      setSuccess(message: 'Producto creado exitosamente');
      
      // Limpiar formulario
      _clearForm();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> updateProduct(String productId) async {
    if (!canSubmit) {
      setError('Por favor completa todos los campos');
      return;
    }
    
    try {
      setLoading();
      
      final updatedProduct = await _productRepository.updateProduct(
        id: productId,
        idSubCategoria: selectedSubCategoria.value?.id,
        nombre: nombreController.text.trim(),
        descripcion: descripcionController.text.trim().isEmpty 
            ? null 
            : descripcionController.text.trim(),
      );
      
      final index = productos.indexWhere((p) => p.id == productId);
      if (index != -1) {
        productos[index] = updatedProduct;
      }
      
      setSuccess(message: 'Producto actualizado exitosamente');
      _clearForm();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> deleteProduct(String productId) async {
    try {
      setLoading();
      
      await _productRepository.deleteProduct(productId);
      productos.removeWhere((p) => p.id == productId);
      
      setSuccess(message: 'Producto eliminado exitosamente');
    } catch (e) {
      setError(e.toString());
    }
  }
  
  void _clearForm() {
    nombreController.clear();
    descripcionController.clear();
    selectedCategoria.value = null;
    selectedSubCategoria.value = null;
    subCategorias.clear();
  }
}