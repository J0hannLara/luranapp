import 'package:supabase_flutter/supabase_flutter.dart';

extension SupabaseExtensions on SupabaseClient {
  Future<List<Map<String, dynamic>>?> fetchWithCache({
    required String table,
    Duration cacheDuration = const Duration(minutes: 5),
  }) async {
    // Implementar lógica de caché aquí
    final response = await from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }
}
