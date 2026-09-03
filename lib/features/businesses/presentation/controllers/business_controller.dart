// lib/features/business/presentation/controllers/business_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/negocio.dart';
import '../../domain/repositories/business_repository_interface.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/utils/view_state.dart';

class BusinessController extends GetxController with ViewStateMixin {
  final BusinessRepositoryInterface _businessRepository;
  final ImageService _imageService;
  final ImagePicker _imagePicker;
  
  BusinessController(
    this._businessRepository, {
    ImageService? imageService,
    ImagePicker? imagePicker,
  })  : _imageService = imageService ?? ImageService(),
        _imagePicker = imagePicker ?? ImagePicker();
  
  // Controllers para el formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  
  // Estado
  final RxList<Negocio> negocios = <Negocio>[].obs;
  final Rx<Negocio?> selectedNegocio = Rx<Negocio?>(null);
  final RxBool isSubmitting = false.obs;
  
  // Estado de imagen
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imageUrl = ''.obs;
  final RxBool isUploadingImage = false.obs;
  
  // Getters
  bool get canSubmit {
    return nombreController.text.trim().isNotEmpty &&
           !isSubmitting.value &&
           !isUploadingImage.value;
  }
  
  bool get hasImage => selectedImage.value != null || imageUrl.value.isNotEmpty;
  
  @override
  void onInit() {
    super.onInit();
    nombreController.addListener(_updateCanSubmit);
    descripcionController.addListener(_updateCanSubmit);
    celularController.addListener(_updateCanSubmit);
  }
  
  @override
  void onClose() {
    nombreController.dispose();
    descripcionController.dispose();
    celularController.dispose();
    super.onClose();
  }
  
  void _updateCanSubmit() {
    update(['business_form']);
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
  
  Future<void> loadUserBusinesses(String userId) async {
    try {
      setLoading();
      final userBusinesses = await _businessRepository.getBusinessesByUser(userId);
      negocios.value = userBusinesses;
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> loadBusiness(String businessId) async {
    try {
      setLoading();
      final business = await _businessRepository.getBusinessById(businessId);
      selectedNegocio.value = business;
      
      // Llenar formulario
      nombreController.text = business.nombre;
      descripcionController.text = business.descripcion ?? '';
      celularController.text = business.celular ?? '';
      
      // Cargar imagen si existe
      if (business.imagen != null && business.imagen!.isNotEmpty) {
        imageUrl.value = business.imagen!;
      }
      
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> registerBusiness(String userId) async {
    // Validar
    if (nombreController.text.trim().isEmpty) {
      setError('Por favor ingresa el nombre del negocio');
      return;
    }
    
    try {
      setLoading();
      isSubmitting.value = true;
      
      // 1. Crear el negocio primero (sin imagen)
      final negocio = await _businessRepository.registerBusiness(
        userId: userId,
        nombre: nombreController.text.trim(),
        descripcion: descripcionController.text.trim().isEmpty 
            ? null 
            : descripcionController.text.trim(),
        celular: celularController.text.trim().isEmpty 
            ? null 
            : celularController.text.trim(),
      );
      
      // 2. Si hay imagen seleccionada, subirla
      if (selectedImage.value != null) {
        try {
          isUploadingImage.value = true;
          
          final uploadedUrl = await _imageService.uploadBusinessImage(
            imageFile: selectedImage.value!,
            businessId: negocio.id,
          );
          
          // 3. Actualizar el negocio con la URL de la imagen
          final updatedNegocio = await _businessRepository.updateBusiness(
            id: negocio.id,
            imagen: uploadedUrl,
          );
          
          selectedNegocio.value = updatedNegocio;
        } catch (imageError) {
          // Si falla la subida de imagen, mostrar advertencia pero continuar
          Get.snackbar(
            'Advertencia',
            'El negocio se creó pero la imagen no pudo subirse: $imageError',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
        } finally {
          isUploadingImage.value = false;
        }
      } else {
        selectedNegocio.value = negocio;
      }
      
      setSuccess(message: 'Negocio registrado exitosamente');
      
      // Limpiar formulario
      _clearForm();
      
      // Navegar a la pantalla de estado
      Get.offNamed('/business/status/${negocio.id}');
    } catch (e) {
      setError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
  
  Future<void> updateBusiness(String businessId) async {
    // Validar
    if (nombreController.text.trim().isEmpty) {
      setError('Por favor ingresa el nombre del negocio');
      return;
    }
    
    try {
      setLoading();
      isSubmitting.value = true;
      
      // 1. Si hay imagen nueva seleccionada, subirla
      String? finalImageUrl;
      if (selectedImage.value != null) {
        isUploadingImage.value = true;
        
        finalImageUrl = await _imageService.uploadBusinessImage(
          imageFile: selectedImage.value!,
          businessId: businessId,
        );
        
        isUploadingImage.value = false;
      } else if (imageUrl.value.isNotEmpty) {
        // Mantener imagen existente
        finalImageUrl = imageUrl.value;
      }
      
      // 2. Actualizar negocio
      final updatedBusiness = await _businessRepository.updateBusiness(
        id: businessId,
        nombre: nombreController.text.trim(),
        descripcion: descripcionController.text.trim().isEmpty 
            ? null 
            : descripcionController.text.trim(),
        celular: celularController.text.trim().isEmpty 
            ? null 
            : celularController.text.trim(),
        imagen: finalImageUrl,
      );
      
      selectedNegocio.value = updatedBusiness;
      setSuccess(message: 'Negocio actualizado exitosamente');
      
      // Actualizar lista
      final index = negocios.indexWhere((n) => n.id == businessId);
      if (index != -1) {
        negocios[index] = updatedBusiness;
      }
      
      // Limpiar imagen temporal
      selectedImage.value = null;
      imageUrl.value = updatedBusiness.imagen ?? '';
      update(['business_image']);
    } catch (e) {
      setError(e.toString());
    } finally {
      isSubmitting.value = false;
      isUploadingImage.value = false;
    }
  }
  
  Future<void> deleteBusiness(String businessId) async {
    try {
      setLoading();
      
      // 1. Eliminar imágenes del storage
      try {
        await _imageService.deleteEntityImages(
          entityId: businessId,
        );
      } catch (e) {
        // Ignorar error si no hay imágenes
      }
      
      // 2. Eliminar negocio de la base de datos
      await _businessRepository.deleteBusiness(businessId);
      
      // Actualizar lista
      negocios.removeWhere((n) => n.id == businessId);
      
      if (selectedNegocio.value?.id == businessId) {
        selectedNegocio.value = null;
      }
      
      setSuccess(message: 'Negocio eliminado exitosamente');
    } catch (e) {
      setError(e.toString());
    }
  }
  
  void _clearForm() {
    nombreController.clear();
    descripcionController.clear();
    celularController.clear();
    selectedImage.value = null;
    imageUrl.value = '';
    update(['business_image']);
  }
}