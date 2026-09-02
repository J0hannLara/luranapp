import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:luranapp/core/database/supabase_client.dart';
import '../errors/exceptions.dart';

abstract class DatabaseRepository {
  final SupabaseClient _client = SupabaseClientService.client;
  
  SupabaseClient get client => _client;
  
  Future<List<Map<String, dynamic>>> fetchAll({
    required String table,
    List<String>? columns,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select(columns?.join(',') ?? '*');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching data: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchWithLimit({
    required String table,
    List<String>? columns,
    int limit = 10,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select(columns?.join(',') ?? '*')
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching data: $e');
    }
  }
  
  Future<Map<String, dynamic>> fetchById({
    required String table,
    required String id,
    List<String>? columns,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select(columns?.join(',') ?? '*')
          .eq('id', id)
          .single();
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching record: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchByField({
    required String table,
    required String field,
    required dynamic value,
    List<String>? columns,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select(columns?.join(',') ?? '*')
          .eq(field, value);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching records: $e');
    }
  }
  
  Future<Map<String, dynamic>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .insert(data)
          .select()
          .single();
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw DatabaseException('Error inserting record: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> insertMany({
    required String table,
    required List<Map<String, dynamic>> dataList,
  }) async {
    try {
      final response = await _client
          .from(table)
          .insert(dataList)
          .select();
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error inserting records: $e');
    }
  }
  
  Future<Map<String, dynamic>> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw DatabaseException('Error updating record: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> updateWhere({
    required String table,
    required String field,
    required dynamic value,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .update(data)
          .eq(field, value)
          .select();
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error updating records: $e');
    }
  }
  
  Future<void> delete({
    required String table,
    required String id,
  }) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e) {
      throw DatabaseException('Error deleting record: $e');
    }
  }
  
  Future<void> deleteWhere({
    required String table,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _client.from(table).delete().eq(field, value);
    } catch (e) {
      throw DatabaseException('Error deleting records: $e');
    }
  }
  
  // Método para contar registros - CORREGIDO
  Future<int> count({
    required String table,
    String? field,
    dynamic value,
  }) async {
    try {
      // Corregido: Usar la sintaxis correcta para contar
      final response = await _client
          .from(table)
          .select('*');
      
      // Aplicar filtro si es necesario
      if (field != null && value != null) {
        final filteredResponse = await _client
            .from(table)
            .select('*')
            .eq(field, value);
        return filteredResponse.length;
      }
      
      return response.length;
    } catch (e) {
      throw DatabaseException('Error counting records: $e');
    }
  }
  
  // Método alternativo para contar usando count explícito
  Future<int> countExact({
    required String table,
    String? field,
    dynamic value,
  }) async {
    try {
      var query = _client.from(table).select('*');
      
      if (field != null && value != null) {
        query = query.eq(field, value);
      }
      
      final response = await query;
      return response.length;
    } catch (e) {
      throw DatabaseException('Error counting records: $e');
    }
  }
}