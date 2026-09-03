// lib/features/auth/presentation/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';

class OnboardingPage extends GetView<AuthController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.person_add_alt_1_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido!',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Completa tu perfil para recibir ofertas personalizadas',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Username
            TextField(
              controller: controller.usernameController,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
                helperText: 'Mínimo 3 caracteres',
              ),
            ),
            const SizedBox(height: 16),
            
            // País (texto plano)
            TextField(
              controller: controller.paisController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'País',
                prefixIcon: Icon(Icons.public),
                border: OutlineInputBorder(),
                hintText: 'Ej: Bolivia, Chile, Perú...',
              ),
            ),
            const SizedBox(height: 16),
            
            // Ciudad (texto plano)
            TextField(
              controller: controller.ciudadController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (controller.canCompleteOnboarding) {
                  controller.completeOnboarding();
                }
              },
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
                hintText: 'Ej: La Paz, Santiago, Lima...',
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
            
            // Botón completar - Se actualiza con GetBuilder
            GetBuilder<AuthController>(
              id: 'onboarding_button',
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.canCompleteOnboarding && !controller.isLoading
                      ? controller.completeOnboarding 
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Completar perfil'),
                );
              },
            ),
            const SizedBox(height: 8),
            
            // Botón saltar
            Obx(() {
              return TextButton(
                onPressed: controller.isLoading 
                    ? null 
                    : controller.skipOnboarding,
                child: const Text('Saltar por ahora'),
              );
            }),
          ],
        ),
      ),
    );
  }
}