// lib/features/product/domain/repositories/product_repository_interface.dart
import '../entities/producto.dart';
import '../entities/categoria.dart';
import '../entities/sub_categoria.dart';

abstract class ProductRepositoryInterface {
  // CRUD de productos
  Future<Producto> createProduct({
    required String idSubCategoria,
    required String nombre,
    String? descripcion,
    String? imagen,
  });
  
  Future<Producto> getProductById(String id);
  
  Future<List<Producto>> getAllProducts();
  
  Future<List<Producto>> getProductsBySubCategoria(String idSubCategoria);
  
  Future<List<Producto>> getProductsByCategoria(String idCategoria);
  
  Future<List<Producto>> searchProducts(String query);
  
  Future<Producto> updateProduct({
    required String id,
    String? idSubCategoria,
    String? nombre,
    String? descripcion,
    String? imagen,
  });
  
  Future<void> deleteProduct(String id);
  
  // Categorías y subcategorías
  Future<List<Categoria>> getAllCategorias();
  
  Future<List<SubCategoria>> getSubCategoriasByCategoria(String idCategoria);
  
  Future<List<SubCategoria>> getAllSubCategorias();
}