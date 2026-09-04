// lib/features/business/presentation/controllers/business_registration_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/negocio.dart';
import '../../domain/entities/sucursal.dart';
import '../../domain/repositories/sucursal_repository_interface.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/utils/view_state.dart';

class BusinessRegistrationController extends GetxController with ViewStateMixin {
  final SucursalRepositoryInterface _sucursalRepository;
  final ImageService _imageService;
  final ImagePicker _imagePicker;
  
  BusinessRegistrationController(
    this._sucursalRepository, {
    ImageService? imageService,
    ImagePicker? imagePicker,
  })  : _imageService = imageService ?? ImageService(),
        _imagePicker = imagePicker ?? ImagePicker();
  
  // Controllers para negocio
  final TextEditingController nombreNegocioController = TextEditingController();
  final TextEditingController descripcionNegocioController = TextEditingController();
  final TextEditingController celularNegocioController = TextEditingController();
  
  // Controllers para sucursal
  final TextEditingController direccionSucursalController = TextEditingController();
  final TextEditingController latitudSucursalController = TextEditingController();
  final TextEditingController longitudSucursalController = TextEditingController();
  final TextEditingController celularSucursalController = TextEditingController();
  
  // Estado
  final RxBool isSubmitting = false.obs;
  final RxBool isUploadingImage = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imageUrl = ''.obs;
  
  // Estado de geolocalización
  final RxBool isGettingLocation = false.obs;
  final RxBool hasLocation = false.obs;
  
  // Datos temporales
  final Rx<Negocio?> tempNegocio = Rx<Negocio?>(null);
  final Rx<Sucursal?> tempSucursal = Rx<Sucursal?>(null);
  
  // Getters para validación
  bool get isBusinessStepValid {
    return nombreNegocioController.text.trim().isNotEmpty;
  }
  
  bool get isSucursalStepValid {
    return direccionSucursalController.text.trim().isNotEmpty;
  }
  
  bool get canSubmitAll {
    return isBusinessStepValid && 
           isSucursalStepValid && 
           !isSubmitting.value &&
           !isUploadingImage.value;
  }
  
  bool get hasImage => selectedImage.value != null || imageUrl.value.isNotEmpty;
  
  @override
  void onInit() {
    super.onInit();
    // Listeners para actualizar UI
    nombreNegocioController.addListener(_updateBusinessForm);
    descripcionNegocioController.addListener(_updateBusinessForm);
    celularNegocioController.addListener(_updateBusinessForm);
    direccionSucursalController.addListener(_updateSucursalForm);
    latitudSucursalController.addListener(_updateSucursalForm);
    longitudSucursalController.addListener(_updateSucursalForm);
    celularSucursalController.addListener(_updateSucursalForm);
  }
  
  @override
  void onClose() {
    nombreNegocioController.dispose();
    descripcionNegocioController.dispose();
    celularNegocioController.dispose();
    direccionSucursalController.dispose();
    latitudSucursalController.dispose();
    longitudSucursalController.dispose();
    celularSucursalController.dispose();
    super.onClose();
  }
  
  void _updateBusinessForm() {
    update(['business_form']);
  }
  
  void _updateSucursalForm() {
    update(['sucursal_form']);
  }
  
  /// Obtener ubicación actual del usuario
  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      setError('');
      
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setError('Permiso de ubicación denegado');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setError('Permiso de ubicación denegado permanentemente. Actívalo en configuración.');
        return;
      }
      
      // Verificar que el GPS esté activado
      if (!await Geolocator.isLocationServiceEnabled()) {
        setError('El GPS está desactivado. Actívalo para obtener tu ubicación.');
        return;
      }
      
      // Obtener posición actual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Actualizar controllers
      latitudSucursalController.text = position.latitude.toStringAsFixed(7);
      longitudSucursalController.text = position.longitude.toStringAsFixed(7);
      hasLocation.value = true;
      
      // Obtener dirección desde las coordenadas (reverse geocoding)
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final address = _formatAddress(placemark);
          
          // Solo llenar dirección si está vacía
          if (direccionSucursalController.text.trim().isEmpty) {
            direccionSucursalController.text = address;
          }
        }
      } catch (geocodingError) {
        // Si falla el geocoding, continuar con solo coordenadas
        print('Error en geocoding: $geocodingError');
      }
      
      _updateSucursalForm();
      
      Get.snackbar(
        'Ubicación obtenida',
        'Se obtuvo tu ubicación actual correctamente',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setError('Error al obtener ubicación: $e');
    } finally {
      isGettingLocation.value = false;
    }
  }
  
  /// Formatear dirección desde placemark
  String _formatAddress(Placemark placemark) {
    final parts = <String>[];
    
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    
    if (parts.isEmpty) {
      return 'Ubicación actual';
    }
    
    return parts.join(', ');
  }
  
  /// Limpiar ubicación
  void clearLocation() {
    latitudSucursalController.clear();
    longitudSucursalController.clear();
    hasLocation.value = false;
    _updateSucursalForm();
  }
  
  /// Seleccionar imagen de la galería
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        update(['business_image']);
      }
    } catch (e) {
      setError('Error al seleccionar imagen: $e');
    }
  }
  
  /// Tomar foto con la cámara
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        update(['business_image']);
      }
    } catch (e) {
      setError('Error al tomar foto: $e');
    }
  }
  
  /// Eliminar imagen seleccionada
  void removeImage() {
    selectedImage.value = null;
    imageUrl.value = '';
    update(['business_image']);
  }
  
  /// Validar y pasar al siguiente paso (sucursal)
  bool validateBusinessStep() {
    if (nombreNegocioController.text.trim().isEmpty) {
      setError('Por favor ingresa el nombre del negocio');
      return false;
    }
    
    // Guardar datos temporales del negocio
    tempNegocio.value = Negocio(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombreNegocioController.text.trim(),
      descripcion: descripcionNegocioController.text.trim().isEmpty 
          ? null 
          : descripcionNegocioController.text.trim(),
      celular: celularNegocioController.text.trim().isEmpty 
          ? null 
          : celularNegocioController.text.trim(),
      imagen: imageUrl.value.isEmpty ? null : imageUrl.value,
      estado: 'pendiente',
    );
    
    setError('');
    return true;
  }
  
  /// Validar sucursal
  bool validateSucursalStep() {
    if (direccionSucursalController.text.trim().isEmpty) {
      setError('Por favor ingresa la dirección de la sucursal');
      return false;
    }
    
    // Validar latitud y longitud si se proporcionan
    double? latitud;
    double? longitud;
    
    if (latitudSucursalController.text.trim().isNotEmpty) {
      latitud = double.tryParse(latitudSucursalController.text.trim());
      if (latitud == null) {
        setError('La latitud debe ser un número válido');
        return false;
      }
      if (latitud < -90 || latitud > 90) {
        setError('La latitud debe estar entre -90 y 90');
        return false;
      }
    }
    
    if (longitudSucursalController.text.trim().isNotEmpty) {
      longitud = double.tryParse(longitudSucursalController.text.trim());
      if (longitud == null) {
        setError('La longitud debe ser un número válido');
        return false;
      }
      if (longitud < -180 || longitud > 180) {
        setError('La longitud debe estar entre -180 y 180');
        return false;
      }
    }
    
    // Guardar datos temporales de la sucursal
    tempSucursal.value = Sucursal(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      idNegocio: tempNegocio.value?.id ?? '',
      direccion: direccionSucursalController.text.trim(),
      latitud: latitud,
      longitud: longitud,
      celular: celularSucursalController.text.trim().isEmpty 
          ? null 
          : celularSucursalController.text.trim(),
      activo: true,
    );
    
    setError('');
    return true;
  }
  
  /// Subir todo (negocio + sucursal)
  Future<void> submitAll(String userId) async {
    if (!canSubmitAll) {
      setError('Por favor completa todos los campos requeridos');
      return;
    }
    
    try {
      setLoading();
      isSubmitting.value = true;
      setError('');
      
      // Crear negocio y sucursal
      final result = await _sucursalRepository.registerBusinessWithSucursal(
        userId: userId,
        nombreNegocio: nombreNegocioController.text.trim(),
        descripcionNegocio: descripcionNegocioController.text.trim().isEmpty 
            ? null 
            : descripcionNegocioController.text.trim(),
        celularNegocio: celularNegocioController.text.trim().isEmpty 
            ? null 
            : celularNegocioController.text.trim(),
        imagenNegocio: null,
        direccionSucursal: direccionSucursalController.text.trim(),
        latitudSucursal: double.tryParse(latitudSucursalController.text.trim()),
        longitudSucursal: double.tryParse(longitudSucursalController.text.trim()),
        celularSucursal: celularSucursalController.text.trim().isEmpty 
            ? null 
            : celularSucursalController.text.trim(),
      );
      
      final negocio = result['negocio'] as Negocio;
      
      // Subir imagen si hay una seleccionada
      if (selectedImage.value != null) {
        isUploadingImage.value = true;
        
        try {
          final uploadedUrl = await _imageService.uploadBusinessImage(
            imageFile: selectedImage.value!,
            businessId: negocio.id,
          );
          
          // Actualizar negocio con la imagen
          await _sucursalRepository.updateSucursal(
            id: (result['sucursal'] as Sucursal).id,
          );
        } catch (imageError) {
          Get.snackbar(
            'Advertencia',
            'El negocio se creó pero la imagen no pudo subirse',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
      
      setSuccess(message: 'Negocio y sucursal registrados exitosamente');
      _clearForm();
      
      Get.offNamed('/business/status/${negocio.id}');
    } catch (e) {
      setError(e.toString());
    } finally {
      isSubmitting.value = false;
      isUploadingImage.value = false;
    }
  }
  
  void _clearForm() {
    nombreNegocioController.clear();
    descripcionNegocioController.clear();
    celularNegocioController.clear();
    direccionSucursalController.clear();
    latitudSucursalController.clear();
    longitudSucursalController.clear();
    celularSucursalController.clear();
    selectedImage.value = null;
    imageUrl.value = '';
    tempNegocio.value = null;
    tempSucursal.value = null;
    hasLocation.value = false;
  }
}