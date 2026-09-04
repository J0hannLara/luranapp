// lib/features/business/presentation/pages/business_status_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import '../controllers/business_registration_controller.dart';

class BusinessStatusPage extends GetView<BusinessRegistrationController> {
  final String businessId;
  
  const BusinessStatusPage({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del negocio'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de revisión
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top,
                  size: 60,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                '¡Negocio en revisión!',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              Text(
                'Tu negocio ha sido registrado exitosamente y está pendiente de aprobación.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '¿Qué significa esto?',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Un administrador revisará tu negocio y lo aprobará en las próximas 24-48 horas. '
                      'Una vez aprobado, podrás empezar a publicar ofertas y gestionar tus sucursales.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Estado del negocio (usando datos temporales si existen)
              Obx(() {
                final negocio = controller.tempNegocio.value;
                if (negocio == null) {
                  return const SizedBox.shrink();
                }
                
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(negocio.estado).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getStatusIcon(negocio.estado),
                        color: _getStatusColor(negocio.estado),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estado: ${negocio.estado.toUpperCase()}',
                        style: TextStyle(
                          color: _getStatusColor(negocio.estado),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              
              const SizedBox(height: 32),
              
              // Botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/customer');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Volver al inicio'),
                ),
              ),
              const SizedBox(height: 8),
              
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de perfil o dashboard
                  Get.offAllNamed('/customer');
                },
                child: const Text('Ir a mi perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      case 'inactivo':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
  
  IconData _getStatusIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.hourglass_top;
      case 'rechazado':
        return Icons.cancel;
      case 'inactivo':
        return Icons.pause_circle;
      default:
        return Icons.info;
    }
  }
}