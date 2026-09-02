import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/environment/supabase_config.dart';

class SupabaseClientService {
  static SupabaseClient? _client;
  
  static Future<SupabaseClient> initialize() async {
    if (_client == null) {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      _client = Supabase.instance.client;
    }
    return _client!;
  }
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase no est� inicializado. Llama a initialize() primero.');
    }
    return _client!;
  }
}
