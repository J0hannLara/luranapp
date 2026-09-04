// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showComingSoon('Configuración');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header de perfil
          _buildProfileHeader(context),
          const SizedBox(height: 24),

          // Tarjeta de estadísticas
          _buildStatsCard(),
          const SizedBox(height: 24),

          // Sección de negocio
          _buildBusinessSection(),
          const SizedBox(height: 24),

          // Opciones de cuenta
          _buildAccountSection(),
          const SizedBox(height: 24),

          // Otras opciones
          _buildOtherSection(),
          const SizedBox(height: 24),

          // Botón de cerrar sesión
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: controller.signOut,
              icon: const Icon(Icons.logout),
              label: const Text(AppStrings.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header del perfil
  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Obx(() {
                final user = controller.currentUser.value;
                if (user?.username.isNotEmpty ?? false) {
                  return Text(
                    user!.username.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  );
                }
                return const Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.primary,
                );
              }),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => Text(
            controller.currentUser.value?.username ?? 'Usuario',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            controller.currentUser.value?.email ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final user = controller.currentUser.value;
          if (user?.pais != null || user?.ciudad != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  [
                    user?.ciudad,
                    user?.pais,
                  ].where((e) => e != null && e.isNotEmpty).join(', '),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('0', 'Reservas'),
          _buildDivider(),
          _buildStatItem('0', 'Favoritos'),
          _buildDivider(),
          _buildStatItem('0', 'Cupones'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: Colors.grey.shade300);
  }

  // Sección de negocio
  // En ProfilePage, actualizar la sección de negocio
  Widget _buildBusinessSection() {
    return Column(
      children: [
        // Card principal para registrar negocio
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.9),
                AppColors.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.toNamed('/business/register');
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_business,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¿Tienes un negocio?',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Publica tus ofertas y llega a más clientes',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Card para ver negocios existentes
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.storefront, color: AppColors.primary),
            ),
            title: const Text(
              'Mis negocios',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Administra tus negocios registrados',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Get.toNamed('/business/my-businesses');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  // Sección de cuenta
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mi cuenta', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.receipt_long_outlined,
          title: 'Mis reservas',
          subtitle: 'Historial de tus compras',
          onTap: () {
            Get.toNamed('/reservations');
          },
        ),
        _buildMenuItem(
          icon: Icons.favorite_border,
          title: 'Favoritos',
          subtitle: 'Negocios y ofertas guardadas',
          onTap: () {
            Get.toNamed('/favorites');
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Alertas y promociones',
          onTap: () {
            _showComingSoon('Notificaciones');
          },
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Mis direcciones',
          subtitle: 'Gestiona tus ubicaciones',
          onTap: () {
            _showComingSoon('Direcciones');
          },
        ),
      ],
    );
  }

  // Otras opciones
  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Otros', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Ayuda y soporte',
          subtitle: 'Preguntas frecuentes',
          onTap: () {
            _showComingSoon('Ayuda');
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'Acerca de',
          subtitle: 'Versión 1.0.0',
          onTap: () {
            _showComingSoon('Acerca de');
          },
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Política de privacidad',
          subtitle: 'Términos y condiciones',
          onTap: () {
            _showComingSoon('Privacidad');
          },
        ),
      ],
    );
  }

  // Widget para items del menú
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Mostrar snackbar de "próximamente"
  void _showComingSoon(String feature) {
    Get.snackbar(
      'Próximamente',
      '$feature estará disponible pronto',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
    );
  }
}
