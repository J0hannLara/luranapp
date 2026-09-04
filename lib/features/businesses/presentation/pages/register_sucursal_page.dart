// lib/features/business/presentation/pages/register_sucursal_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';
import '../controllers/business_registration_controller.dart';

class RegisterSucursalPage extends GetView<BusinessRegistrationController> {
  const RegisterSucursalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra tu sucursal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.location_on,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Ubicación de tu negocio',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Paso 2 de 2: Agrega la dirección principal',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Botón para obtener ubicación actual
            Obx(() {
              return ElevatedButton.icon(
                onPressed: controller.isGettingLocation.value 
                    ? null 
                    : controller.getCurrentLocation,
                icon: controller.isGettingLocation.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  controller.isGettingLocation.value
                      ? 'Obteniendo ubicación...'
                      : 'Usar mi ubicación actual',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            }),
            
            const SizedBox(height: 16),
            
            // O separador
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'O ingresa manualmente',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Dirección
            TextField(
              controller: controller.direccionSucursalController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Dirección *',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                hintText: 'Ej: Av. Principal #123, Zona Central',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            
            // Latitud y Longitud
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.latitudSucursalController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Latitud',
                      prefixIcon: const Icon(Icons.swap_vert),
                      border: const OutlineInputBorder(),
                      hintText: 'Ej: -16.5000',
                      suffixIcon: controller.hasLocation.value
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller.longitudSucursalController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Longitud',
                      prefixIcon: const Icon(Icons.swap_horiz),
                      border: const OutlineInputBorder(),
                      hintText: 'Ej: -68.1500',
                      suffixIcon: controller.hasLocation.value
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            
            // Botón para limpiar ubicación
            Obx(() {
              if (!controller.hasLocation.value) {
                return const SizedBox.shrink();
              }
              
              return TextButton.icon(
                onPressed: controller.clearLocation,
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Limpiar ubicación'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
              );
            }),
            
            const SizedBox(height: 16),
            
            // Celular de la sucursal
            TextField(
              controller: controller.celularSucursalController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (controller.isSucursalStepValid) {
                  _submit(authController);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Celular de la sucursal (opcional)',
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
            
            // Botón de registro final
            GetBuilder<BusinessRegistrationController>(
              id: 'sucursal_form',
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.isSucursalStepValid && !controller.isSubmitting.value
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
                    return const Text('Registrar negocio y sucursal');
                  }),
                );
              },
            ),
            const SizedBox(height: 8),
            
            // Botón volver
            TextButton(
              onPressed: controller.isSubmitting.value 
                  ? null 
                  : () => Get.back(),
              child: const Text('Volver a datos del negocio'),
            ),
          ],
        ),
      ),
    );
  }
  
  // Indicador de progreso (Paso 2 de 2)
  Widget _buildProgressIndicator() {
    return Row(
      children: [
        // Paso 1 (completado)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Negocio',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        // Línea conectora
        Container(
          width: 40,
          height: 2,
          color: AppColors.primary,
        ),
        // Paso 2 (activo)
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
                  Icons.location_on,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sucursal',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _submit(AuthController authController) {
    if (controller.validateSucursalStep()) {
      final userId = authController.currentUser.value?.id;
      if (userId != null) {
        controller.submitAll(userId);
      }
    }
  }
}