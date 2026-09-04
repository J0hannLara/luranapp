// lib/features/business/presentation/pages/my_businesses_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:luranapp/features/businesses/domain/entities/negocio.dart';
import '../controllers/business_management_controller.dart';

class MyBusinessesPage extends GetView<BusinessManagementController> {
  const MyBusinessesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis negocios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          // Mostrar loading
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Mostrar error
          if (controller.isError && controller.negocios.isEmpty) {
            return _buildErrorState();
          }

          // Mostrar estado vacío
          if (controller.negocios.isEmpty) {
            return _buildEmptyState();
          }

          // Mostrar lista de negocios
          return _buildBusinessList();
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/business/register');
        },
        icon: const Icon(Icons.add_business),
        label: const Text('Nuevo negocio'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Lista de negocios
  Widget _buildBusinessList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: controller.negocios.length,
      itemBuilder: (context, index) {
        final negocio = controller.negocios[index];
        return _buildBusinessCard(negocio);
      },
    );
  }

  // Card de negocio individual
  Widget _buildBusinessCard(Negocio negocio) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed('/business/dashboard/${negocio.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del negocio
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: negocio.imagen != null && negocio.imagen!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          negocio.imagen!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildBusinessIcon();
                          },
                        ),
                      )
                    : _buildBusinessIcon(),
              ),
              const SizedBox(width: 16),

              // Información del negocio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      negocio.nombre,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (negocio.descripcion != null &&
                        negocio.descripcion!.isNotEmpty)
                      Text(
                        negocio.descripcion!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    _buildStatusBadge(negocio.estado),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Flecha
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Icono de negocio
  Widget _buildBusinessIcon() {
    return const Icon(Icons.storefront, size: 32, color: AppColors.primary);
  }

  // Badge de estado
  Widget _buildStatusBadge(String estado) {
    final Color color;
    final IconData icon;
    final String label;

    switch (estado.toLowerCase()) {
      case 'activo':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Activo';
        break;
      case 'pendiente':
        color = Colors.orange;
        icon = Icons.hourglass_top;
        label = 'Pendiente';
        break;
      case 'rechazado':
        color = Colors.red;
        icon = Icons.cancel;
        label = 'Rechazado';
        break;
      case 'inactivo':
        color = Colors.grey;
        icon = Icons.pause_circle;
        label = 'Inactivo';
        break;
      default:
        color = Colors.blue;
        icon = Icons.info;
        label = estado;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No tienes negocios registrados',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Registra tu primer negocio y empieza a publicar ofertas',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/business/register');
              },
              icon: const Icon(Icons.add_business),
              label: const Text('Registrar negocio'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estado de error
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar tus negocios',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.retryLoad,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
