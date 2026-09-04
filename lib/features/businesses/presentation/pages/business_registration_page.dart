// lib/features/business/presentation/pages/register_business_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import '../controllers/business_registration_controller.dart';

class RegisterBusinessPage extends GetView<BusinessRegistrationController> {
  const RegisterBusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Paso 1 de 2: Información básica',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Formulario
            TextField(
              controller: controller.nombreNegocioController,
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
              controller: controller.descripcionNegocioController,
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
              controller: controller.celularNegocioController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (controller.isBusinessStepValid) {
                  _continueToSucursal();
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
            
            // Indicador de progreso
            _buildProgressIndicator(),
            
            const SizedBox(height: 24),
            
            // Botón de continuar
            GetBuilder<BusinessRegistrationController>(
              id: 'business_form',
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.isBusinessStepValid 
                      ? _continueToSucursal
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continuar'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
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
    return GetBuilder<BusinessRegistrationController>(
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
            const SizedBox(height: 8),
            Text(
              'Opcional: Agrega una imagen de tu negocio',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildImagePreview(BusinessRegistrationController controller) {
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
  
  // Indicador de progreso (Paso 1 de 2)
  Widget _buildProgressIndicator() {
    return Row(
      children: [
        // Paso 1 (activo)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Negocio',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Línea conectora
        Container(
          width: 40,
          height: 2,
          color: Colors.grey.shade300,
        ),
        // Paso 2 (inactivo)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sucursal',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _continueToSucursal() {
    if (controller.validateBusinessStep()) {
      Get.toNamed('/business/register/sucursal');
    }
  }
}