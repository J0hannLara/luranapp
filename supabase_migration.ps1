# SupabaseMigration.ps1
# Script para migrar la estructura de Flutter de API REST a Supabase

param(
    [string]$ProjectPath = "."
)

# Función para crear directorios si no existen
function New-DirectoryIfNotExists {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "✓ Creado: $Path" -ForegroundColor Green
    } else {
        Write-Host "→ Ya existe: $Path" -ForegroundColor Yellow
    }
}

# Función para mover archivos con respaldo
function Move-FileWithBackup {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )
    
    if (Test-Path $SourcePath) {
        # Crear directorio destino si no existe
        $destDir = Split-Path $DestinationPath -Parent
        New-DirectoryIfNotExists -Path $destDir
        
        # Mover archivo
        Move-Item -Path $SourcePath -Destination $DestinationPath -Force
        Write-Host "✓ Movido: $SourcePath → $DestinationPath" -ForegroundColor Cyan
    } else {
        Write-Host "✗ No encontrado: $SourcePath" -ForegroundColor Red
    }
}

# Función para eliminar archivos y carpetas de API REST
function Remove-ApiRestStructure {
    Write-Host "`n=== Eliminando estructura API REST ===" -ForegroundColor Magenta
    
    $apiPaths = @(
        "lib\core\network",
        "lib\core\network\api_client.dart",
        "lib\core\network\api_endpoints.dart",
        "lib\core\network\api_response.dart"
    )
    
    foreach ($path in $apiPaths) {
        $fullPath = Join-Path $ProjectPath $path
        if (Test-Path $fullPath) {
            Remove-Item -Path $fullPath -Recurse -Force
            Write-Host "✓ Eliminado: $path" -ForegroundColor Red
        } else {
            Write-Host "→ No existe: $path" -ForegroundColor Yellow
        }
    }
}

# Función para crear estructura Supabase
function New-SupabaseStructure {
    Write-Host "`n=== Creando estructura Supabase ===" -ForegroundColor Magenta
    
    $supabaseDirs = @(
        # Config
        "lib\config\environment",
        
        # Core Database
        "lib\core\database",
        
        # Features con capa de datos
        "lib\features\auth\data\models",
        "lib\features\auth\data\repositories",
        "lib\features\auth\domain\repositories",
        
        "lib\features\businesses\data\models",
        "lib\features\businesses\data\repositories",
        "lib\features\businesses\domain\entities",
        
        "lib\features\business_dashboard\data\models",
        "lib\features\business_dashboard\data\repositories",
        "lib\features\business_dashboard\domain\entities",
        
        "lib\features\explore\data\models",
        "lib\features\explore\data\repositories",
        "lib\features\explore\domain\entities",
        
        "lib\features\favorites\data\models",
        "lib\features\favorites\data\repositories",
        "lib\features\favorites\domain\entities",
        
        "lib\features\home\data\models",
        "lib\features\home\data\repositories",
        "lib\features\home\domain\entities",
        
        "lib\features\notifications\data",
        "lib\features\notifications\domain",
        
        "lib\features\offers\data",
        "lib\features\offers\domain",
        
        "lib\features\orders\data",
        "lib\features\orders\domain",
        
        "lib\features\profile\data",
        "lib\features\profile\domain"
    )
    
    foreach ($dir in $supabaseDirs) {
        $fullPath = Join-Path $ProjectPath $dir
        New-DirectoryIfNotExists -Path $fullPath
    }
}

# Función para crear archivos base de Supabase
function New-SupabaseFiles {
    Write-Host "`n=== Creando archivos base de Supabase ===" -ForegroundColor Magenta
    
    # 1. Configuración de Supabase
    $supabaseConfig = @"
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
"@
    $supabaseConfigPath = Join-Path $ProjectPath "lib\config\environment\supabase_config.dart"
    Set-Content -Path $supabaseConfigPath -Value $supabaseConfig -Force
    Write-Host "✓ Creado: supabase_config.dart" -ForegroundColor Green
    
    # 2. Cliente Supabase
    $supabaseClient = @"
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
      throw Exception('Supabase no está inicializado. Llama a initialize() primero.');
    }
    return _client!;
  }
}
"@
    $supabaseClientPath = Join-Path $ProjectPath "lib\core\database\supabase_client.dart"
    Set-Content -Path $supabaseClientPath -Value $supabaseClient -Force
    Write-Host "✓ Creado: supabase_client.dart" -ForegroundColor Green
    
    # 3. Repositorio base
    $baseRepository = @"
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/supabase_client.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

abstract class DatabaseRepository {
  final SupabaseClient _client = SupabaseClientService.client;
  
  SupabaseClient get client => _client;
  
  Future<List<Map<String, dynamic>>> fetchAll({
    required String table,
    List<String>? columns,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _client.from(table).select(columns?.join(','));
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching data: ${e.toString()}');
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
          .select(columns?.join(','))
          .eq('id', id)
          .single();
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw DatabaseException('Error fetching record: ${e.toString()}');
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
      throw DatabaseException('Error inserting record: ${e.toString()}');
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
      throw DatabaseException('Error inserting records: ${e.toString()}');
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
      throw DatabaseException('Error updating record: ${e.toString()}');
    }
  }
  
  Future<void> delete({
    required String table,
    required String id,
  }) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e) {
      throw DatabaseException('Error deleting record: ${e.toString()}');
    }
  }
}
"@
    $baseRepoPath = Join-Path $ProjectPath "lib\core\database\database_repository.dart"
    Set-Content -Path $baseRepoPath -Value $baseRepository -Force
    Write-Host "✓ Creado: database_repository.dart" -ForegroundColor Green
    
    # 4. Tablas de la base de datos
    $dbTables = @"
class DatabaseTables {
  static const String users = 'users';
  static const String businesses = 'businesses';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String orderItems = 'order_items';
  static const String favorites = 'favorites';
  static const String reviews = 'reviews';
  static const String notifications = 'notifications';
  static const String offers = 'offers';
  static const String categories = 'categories';
}
"@
    $dbTablesPath = Join-Path $ProjectPath "lib\core\constants\database_tables.dart"
    Set-Content -Path $dbTablesPath -Value $dbTables -Force
    Write-Host "✓ Creado: database_tables.dart" -ForegroundColor Green
    
    # 5. Extensión de Supabase
    $supabaseExtension = @"
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
"@
    $supabaseExtPath = Join-Path $ProjectPath "lib\core\extensions\supabase_extensions.dart"
    Set-Content -Path $supabaseExtPath -Value $supabaseExtension -Force
    Write-Host "✓ Creado: supabase_extensions.dart" -ForegroundColor Green
}

# Función para actualizar pubspec.yaml
function Update-PubspecYaml {
    Write-Host "`n=== Actualizando pubspec.yaml ===" -ForegroundColor Magenta
    
    $pubspecPath = Join-Path $ProjectPath "pubspec.yaml"
    if (Test-Path $pubspecPath) {
        $content = Get-Content $pubspecPath -Raw
        
        # Agregar dependencias de Supabase si no existen
        $dependencies = @"
  supabase_flutter: ^2.0.0
  supabase_auth_ui: ^0.4.0
"@
        
        if ($content -notmatch "supabase_flutter") {
            $content = $content -replace "(dependencies:\s*\n)", "`$1$dependencies`n"
            Set-Content -Path $pubspecPath -Value $content -Force
            Write-Host "✓ Actualizado pubspec.yaml con dependencias de Supabase" -ForegroundColor Green
        } else {
            Write-Host "→ Las dependencias de Supabase ya existen" -ForegroundColor Yellow
        }
    }
}

# Función para crear repositorio de autenticación
function New-AuthRepository {
    Write-Host "`n=== Creando repositorio de autenticación ===" -ForegroundColor Magenta
    
    $authRepoInterface = @"
abstract class AuthRepositoryInterface {
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });
  
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });
  
  Future<void> signOut();
  
  Future<User?> getCurrentUser();
  
  Future<void> resetPassword(String email);
  
  Stream<User?> get authStateChanges;
}
"@
    $authRepoInterfacePath = Join-Path $ProjectPath "lib\features\auth\domain\repositories\auth_repository_interface.dart"
    Set-Content -Path $authRepoInterfacePath -Value $authRepoInterface -Force
    Write-Host "✓ Creado: auth_repository_interface.dart" -ForegroundColor Green
    
    $authRepoImpl = @"
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/supabase_client.dart';
import '../../../core/constants/database_tables.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final SupabaseClient _client = SupabaseClientService.client;
  
  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      final userData = await _client
          .from(DatabaseTables.users)
          .select()
          .eq('id', response.user!.id)
          .single();
      
      return User.fromJson(userData);
    } catch (e) {
      throw AuthException('Error al iniciar sesión: ${e.toString()}');
    }
  }
  
  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user == null) {
        throw AuthException('Error al crear usuario');
      }
      
      // Insertar en tabla de usuarios
      final userData = await _client
          .from(DatabaseTables.users)
          .insert({
            'id': response.user!.id,
            'email': email,
            'name': name,
          })
          .select()
          .single();
      
      return User.fromJson(userData);
    } catch (e) {
      throw AuthException('Error al registrarse: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  @override
  Future<User?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;
    
    final userData = await _client
        .from(DatabaseTables.users)
        .select()
        .eq('id', session.user.id)
        .maybeSingle();
    
    return userData != null ? User.fromJson(userData) : null;
  }
  
  @override
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
  
  @override
  Stream<User?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((state) async {
      if (state.session == null) return null;
      
      final userData = await _client
          .from(DatabaseTables.users)
          .select()
          .eq('id', state.session!.user.id)
          .maybeSingle();
      
      return userData != null ? User.fromJson(userData) : null;
    }).asyncExpand((userFuture) => Stream.fromFuture(userFuture));
  }
}
"@
    $authRepoImplPath = Join-Path $ProjectPath "lib\features\auth\data\repositories\auth_repository.dart"
    Set-Content -Path $authRepoImplPath -Value $authRepoImpl -Force
    Write-Host "✓ Creado: auth_repository.dart" -ForegroundColor Green
}

# Función principal
function Start-Migration {
    Write-Host "`n=========================================" -ForegroundColor Cyan
    Write-Host "   MIGRACIÓN A SUPABASE - FLUTTER APP" -ForegroundColor Cyan
    Write-Host "=========================================`n" -ForegroundColor Cyan
    
    # 1. Crear backup
    Write-Host "Creando backup de la estructura actual..." -ForegroundColor Yellow
    $backupPath = Join-Path $ProjectPath "backup_before_supabase"
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        Copy-Item -Path (Join-Path $ProjectPath "lib") -Destination $backupPath -Recurse -Force
        Write-Host "✓ Backup creado en: $backupPath" -ForegroundColor Green
    }
    
    # 2. Eliminar estructura API REST
    Remove-ApiRestStructure
    
    # 3. Crear nueva estructura
    New-SupabaseStructure
    
    # 4. Crear archivos base
    New-SupabaseFiles
    
    # 5. Actualizar pubspec.yaml
    Update-PubspecYaml
    
    # 6. Crear repositorio de autenticación
    New-AuthRepository
    
    Write-Host "`n=========================================" -ForegroundColor Cyan
    Write-Host "   MIGRACIÓN COMPLETADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "=========================================`n" -ForegroundColor Cyan
    
    Write-Host "Pasos siguientes:" -ForegroundColor Yellow
    Write-Host "1. Actualizar las credenciales en lib/config/environment/supabase_config.dart"
    Write-Host "2. Ejecutar 'flutter pub get' para instalar dependencias"
    Write-Host "3. Crear las tablas en Supabase según lib/core/constants/database_tables.dart"
    Write-Host "4. Actualizar los controllers para usar los repositorios"
    Write-Host "5. Eliminar la carpeta backup_before_supabase cuando todo funcione"
}

# Ejecutar migración
Start-Migration