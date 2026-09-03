// lib/core/services/image_service.dart
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/supabase_client.dart';
import '../errors/exceptions.dart';

class ImageService {
  final SupabaseClient _client = SupabaseClientService.client;
  final _uuid = const Uuid();
  
  // Bucket por defecto para imágenes
  static const String defaultBucket = 'negocios';
  
  // Calidad de compresión WebP (0-100)
  final int webpQuality;
  
  // Tamaño máximo de imagen (en bytes)
  final int maxImageSize;
  
  ImageService({
    this.webpQuality = 80,
    this.maxImageSize = 5 * 1024 * 1024, // 5MB por defecto
  });
  
  /// Convierte un archivo de imagen a formato WebP
  Future<File?> convertToWebp(File file) async {
    try {
      final targetPath = '${file.path}.webp';
      
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        format: CompressFormat.webp,
        quality: webpQuality,
      );
      
      if (result == null) {
        return null;
      }
      
      final webpFile = File(result.path);
      
      // Verificar que el archivo convertido no exceda el tamaño máximo
      final fileSize = await webpFile.length();
      if (fileSize > maxImageSize) {
        throw ImageException('La imagen excede el tamaño máximo permitido');
      }
      
      return webpFile;
    } catch (e) {
      if (e is ImageException) rethrow;
      throw ImageException('Error al convertir imagen a WebP: $e');
    }
  }
  
  /// Sube una imagen al bucket y retorna la URL pública
  /// El path en el bucket ya NO incluye el tipo de entidad
  /// porque el bucket ya se llama 'negocios'
  Future<String> uploadImage({
    required File imageFile,
    required String entityId,    // ID del negocio, oferta, etc.
    String bucket = defaultBucket,
    String? fileName,
  }) async {
    try {
      // 1. Convertir a WebP
      final webpFile = await convertToWebp(imageFile);
      if (webpFile == null) {
        throw ImageException('No se pudo convertir la imagen a WebP');
      }
      
      // 2. Generar nombre único para el archivo
      final generatedFileName = fileName ?? _generateFileName();
      final fileExtension = '.webp';
      final finalFileName = generatedFileName.endsWith(fileExtension) 
          ? generatedFileName 
          : '$generatedFileName$fileExtension';
      
      // 3. Construir la ruta SIN el nombre del bucket
      // El bucket ya es 'negocios', así que el path es: {entityId}/{finalFileName}
      final storagePath = '$entityId/$finalFileName';
      
      // 4. Subir archivo al bucket
      await _client.storage
          .from(bucket)
          .upload(
            storagePath,
            webpFile,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'image/webp',
            ),
          );
      
      // 5. Obtener URL pública
      // La URL será: /storage/v1/object/negocios/{entityId}/foto.webp
      final publicUrl = _client.storage
          .from(bucket)
          .getPublicUrl(storagePath);
      
      return publicUrl;
    } catch (e) {
      if (e is ImageException) rethrow;
      throw ImageException('Error al subir imagen: $e');
    }
  }
  
  /// Sube una imagen de negocio y retorna la URL
  /// Path: {businessId}/foto.webp
  Future<String> uploadBusinessImage({
    required File imageFile,
    required String businessId,
  }) async {
    return uploadImage(
      imageFile: imageFile,
      entityId: businessId,
      fileName: 'foto',
    );
  }
  
  /// Elimina una imagen del bucket
  Future<void> deleteImage({
    required String url,
    String bucket = defaultBucket,
  }) async {
    try {
      // Extraer la ruta del archivo de la URL completa
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      // Buscar el bucket en la URL
      final bucketIndex = pathSegments.indexOf('object');
      if (bucketIndex == -1) {
        throw ImageException('URL de imagen inválida');
      }
      
      // Construir la ruta del archivo
      // La URL es: /storage/v1/object/negocios/{id}/foto.webp
      // pathSegments: ['storage', 'v1', 'object', 'negocios', '{id}', 'foto.webp']
      final storagePath = pathSegments.sublist(bucketIndex + 2).join('/');
      
      await _client.storage
          .from(bucket)
          .remove([storagePath]);
    } catch (e) {
      if (e is ImageException) rethrow;
      throw ImageException('Error al eliminar imagen: $e');
    }
  }
  
  /// Elimina una imagen por su ruta en el bucket
  Future<void> deleteImageByPath({
    required String path,
    String bucket = defaultBucket,
  }) async {
    try {
      await _client.storage
          .from(bucket)
          .remove([path]);
    } catch (e) {
      throw ImageException('Error al eliminar imagen: $e');
    }
  }
  
  /// Elimina todas las imágenes de una entidad
  Future<void> deleteEntityImages({
    required String entityId,
    String bucket = defaultBucket,
  }) async {
    try {
      // Listar archivos en la carpeta del negocio
      final files = await _client.storage
          .from(bucket)
          .list(path: entityId);
      
      if (files.isNotEmpty) {
        final paths = files
            .map((file) => '$entityId/${file.name}')
            .toList();
        
        await _client.storage
            .from(bucket)
            .remove(paths);
      }
    } catch (e) {
      throw ImageException('Error al eliminar imágenes de la entidad: $e');
    }
  }
  
  // Métodos privados
  String _generateFileName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid = _uuid.v4().substring(0, 8);
    return 'img_${timestamp}_$uuid';
  }
}