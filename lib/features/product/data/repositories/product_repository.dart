// lib/features/product/data/repositories/product_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/database_repository.dart';
import '../../../../core/database/supabase_client.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/producto.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/sub_categoria.dart';
import '../../domain/repositories/product_repository_interface.dart';

class ProductRepository extends DatabaseRepository implements ProductRepositoryInterface {
  final SupabaseClient _client = SupabaseClientService.client;
  
  @override
  Future<Producto> createProduct({
    required String idSubCategoria,
    required String nombre,
    String? descripcion,
    String? imagen,
  }) async {
    try {
      final productData = await insert(
        table: DatabaseTables.productos,
        data: {
          'id_sub_categoria': idSubCategoria,
          'nombre': nombre,
          'descripcion': descripcion,
          'imagen': imagen,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      return Producto.fromJson(productData);
    } catch (e) {
      throw DatabaseException('Error al crear producto: $e');
    }
  }
  
  @override
  Future<Producto> getProductById(String id) async {
    try {
      final productData = await fetchById(
        table: DatabaseTables.productos,
        id: id,
      );
      
      return Producto.fromJson(productData);
    } catch (e) {
      throw DatabaseException('Error al obtener producto: $e');
    }
  }
  
  @override
  Future<List<Producto>> getAllProducts() async {
    try {
      final response = await _client
          .from(DatabaseTables.productos)
          .select()
          .order('nombre');
      
      return response
          .map((data) => Producto.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos: $e');
    }
  }
  
  @override
  Future<List<Producto>> getProductsBySubCategoria(String idSubCategoria) async {
    try {
      final response = await _client
          .from(DatabaseTables.productos)
          .select()
          .eq('id_sub_categoria', idSubCategoria)
          .order('nombre');
      
      return response
          .map((data) => Producto.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos por subcategoría: $e');
    }
  }
  
  @override
  Future<List<Producto>> getProductsByCategoria(String idCategoria) async {
    try {
      // Obtener subcategorías de la categoría
      final subCategorias = await _client
          .from(DatabaseTables.subCategorias)
          .select('id')
          .eq('id_categoria', idCategoria);
      
      final subCategoriaIds = subCategorias
          .map((sc) => sc['id'] as String)
          .toList();
      
      if (subCategoriaIds.isEmpty) {
        return [];
      }
      
      final response = await _client
          .from(DatabaseTables.productos)
          .select()
          .inFilter('id_sub_categoria', subCategoriaIds)
          .order('nombre');
      
      return response
          .map((data) => Producto.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos por categoría: $e');
    }
  }
  
  @override
  Future<List<Producto>> searchProducts(String query) async {
    try {
      final response = await _client
          .from(DatabaseTables.productos)
          .select()
          .ilike('nombre', '%$query%')
          .order('nombre')
          .limit(20);
      
      return response
          .map((data) => Producto.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al buscar productos: $e');
    }
  }
  
  @override
  Future<Producto> updateProduct({
    required String id,
    String? idSubCategoria,
    String? nombre,
    String? descripcion,
    String? imagen,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (idSubCategoria != null) updateData['id_sub_categoria'] = idSubCategoria;
      if (nombre != null) updateData['nombre'] = nombre;
      if (descripcion != null) updateData['descripcion'] = descripcion;
      if (imagen != null) updateData['imagen'] = imagen;
      
      final productData = await update(
        table: DatabaseTables.productos,
        id: id,
        data: updateData,
      );
      
      return Producto.fromJson(productData);
    } catch (e) {
      throw DatabaseException('Error al actualizar producto: $e');
    }
  }
  
  @override
  Future<void> deleteProduct(String id) async {
    try {
      await delete(
        table: DatabaseTables.productos,
        id: id,
      );
    } catch (e) {
      throw DatabaseException('Error al eliminar producto: $e');
    }
  }
  
  @override
  Future<List<Categoria>> getAllCategorias() async {
    try {
      final response = await _client
          .from(DatabaseTables.categorias)
          .select()
          .order('nombre');
      
      return response
          .map((data) => Categoria.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener categorías: $e');
    }
  }
  
  @override
  Future<List<SubCategoria>> getSubCategoriasByCategoria(String idCategoria) async {
    try {
      final response = await _client
          .from(DatabaseTables.subCategorias)
          .select()
          .eq('id_categoria', idCategoria)
          .order('nombre');
      
      return response
          .map((data) => SubCategoria.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener subcategorías: $e');
    }
  }
  
  @override
  Future<List<SubCategoria>> getAllSubCategorias() async {
    try {
      final response = await _client
          .from(DatabaseTables.subCategorias)
          .select()
          .order('nombre');
      
      return response
          .map((data) => SubCategoria.fromJson(data))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener subcategorías: $e');
    }
  }
}