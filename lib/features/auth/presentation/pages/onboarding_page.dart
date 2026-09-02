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
            
            // Username (no necesita Obx)
            TextField(
              controller: controller.usernameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // País - Solo este widget necesita Obx
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedCountryCode.value.isEmpty 
                    ? null 
                    : controller.selectedCountryCode.value,
                decoration: const InputDecoration(
                  labelText: 'País',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Selecciona tu país'),
                items: controller.countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country.code,
                    child: Text(country.name),
                  );
                }).toList(),
                onChanged: controller.isLoadingCountries.value
                    ? null
                    : (value) {
                        if (value != null) {
                          controller.selectCountry(value);
                        }
                      },
              );
            }),
            const SizedBox(height: 16),
            
            // Ciudad - Solo este widget necesita Obx
            Obx(() {
              return TextField(
                controller: controller.ciudadController,
                enabled: controller.selectedCountryCode.value.isNotEmpty,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
              );
            }),
            
            // Mensaje de error - Solo este widget necesita Obx
            Obx(() {
              if (controller.errorMessage.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  controller.errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // Botón - Solo este widget necesita Obx
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading 
                    ? null 
                    : controller.completeOnboarding,
                child: const Text('Completar perfil'),
              );
            }),
          ],
        ),
      ),
    );
  }
}