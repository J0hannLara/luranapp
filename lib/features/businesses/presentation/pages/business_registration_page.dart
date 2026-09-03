// lib/features/business/presentation/pages/register_business_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';
import '../controllers/business_controller.dart';

class RegisterBusinessPage extends GetView<BusinessController> {
  const RegisterBusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra tu negocio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Selector de imagen
            _buildImagePicker(),
            const SizedBox(height: 32),
            
            Text(
              'Cuéntanos sobre tu negocio',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Completa la información básica para empezar a publicar ofertas',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Formulario
            TextField(
              controller: controller.nombreController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre del negocio *',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
                hintText: 'Ej: Tienda de Ropa XYZ',
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: controller.descripcionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                hintText: 'Describe brevemente tu negocio...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: controller.celularController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (controller.canSubmit) {
                  _submit(authController);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Celular',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                hintText: 'Ej: +591 70000000',
              ),
            ),
            
            // Mensaje de error
            Obx(() {
              if (controller.errorMessage.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // Botón de registro
            GetBuilder<BusinessController>(
              id: 'business_form',
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.canSubmit 
                      ? () => _submit(authController)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Obx(() {
                    if (controller.isSubmitting.value) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    if (controller.isUploadingImage.value) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Subiendo imagen...'),
                        ],
                      );
                    }
                    return const Text('Registrar negocio');
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget para seleccionar imagen
  Widget _buildImagePicker() {
    return GetBuilder<BusinessController>(
      id: 'business_image',
      builder: (controller) {
        return Column(
          children: [
            // Vista previa de la imagen
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _buildImagePreview(controller),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: controller.pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: controller.takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
                if (controller.hasImage) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.removeImage,
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    tooltip: 'Eliminar imagen',
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildImagePreview(BusinessController controller) {
    // Si hay imagen seleccionada
    if (controller.selectedImage.value != null) {
      return Image.file(
        controller.selectedImage.value!,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
      );
    }
    
    // Si hay URL de imagen existente
    if (controller.imageUrl.value.isNotEmpty) {
      return Image.network(
        controller.imageUrl.value,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    
    return _buildPlaceholder();
  }
  
  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.storefront,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Text(
          'Imagen del negocio',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
  
  void _submit(AuthController authController) {
    final userId = authController.currentUser.value?.id;
    if (userId != null) {
      controller.registerBusiness(userId);
    }
  }
}