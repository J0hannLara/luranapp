// lib/features/business_dashboard/presentation/pages/business_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/businesses/domain/entities/negocio_completo.dart';
import 'package:luranapp/features/businesses/domain/entities/sucursal.dart';
import 'package:luranapp/features/businesses/domain/entities/usuario_negocio.dart';
import 'package:luranapp/features/product/domain/entities/producto.dart';
import '../controllers/business_dashboard_controller.dart';

class BusinessDashboardPage extends GetView<BusinessDashboardController> {
  final String businessId;

  const BusinessDashboardPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard del negocio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showBusinessSettings();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.isError && controller.negocioCompleto.value == null) {
            return _buildErrorState();
          }

          if (controller.negocioCompleto.value == null) {
            return _buildEmptyState();
          }

          return _buildDashboardContent(controller.negocioCompleto.value!);
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMenu();
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Contenido principal del dashboard
  Widget _buildDashboardContent(NegocioCompleto negocioCompleto) {
    return RefreshIndicator(
      onRefresh: controller.loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header del negocio
          _buildBusinessHeader(negocioCompleto),
          const SizedBox(height: 24),

          // Estadísticas rápidas
          _buildStatsGrid(negocioCompleto),
          const SizedBox(height: 24),

          // Sucursales
          _buildSucursalesSection(negocioCompleto.sucursales),
          const SizedBox(height: 24),

          // Productos
          _buildProductosSection(negocioCompleto.productos),
          const SizedBox(height: 24),

          // Usuarios
          _buildUsuariosSection(negocioCompleto.usuarios),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Header del negocio
  Widget _buildBusinessHeader(NegocioCompleto negocioCompleto) {
    final negocio = negocioCompleto.negocio;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.9),
            AppColors.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: negocio.imagen != null && negocio.imagen!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      negocio.nombre,
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildStatusBadge(negocio.estado),
                  ],
                ),
              ),
            ],
          ),
          if (negocio.descripcion != null &&
              negocio.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              negocio.descripcion!,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // Icono de negocio
  Widget _buildBusinessIcon() {
    return const Icon(Icons.storefront, size: 40, color: Colors.white);
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
        label = 'Pendiente de aprobación';
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Grid de estadísticas
  Widget _buildStatsGrid(NegocioCompleto negocioCompleto) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.location_on,
            label: 'Sucursales',
            value: negocioCompleto.sucursales.length.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2,
            label: 'Productos',
            value: negocioCompleto.productos.length.toString(),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            label: 'Usuarios',
            value: negocioCompleto.usuarios.length.toString(),
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Sección de sucursales
  Widget _buildSucursalesSection(List<Sucursal> sucursales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sucursales', style: AppTextStyles.h3),
            TextButton.icon(
              onPressed: () {
                _addSucursal();
              },
              icon: const Icon(Icons.add_location_alt, size: 18),
              label: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (sucursales.isEmpty)
          _buildEmptySection(
            icon: Icons.location_on,
            title: 'Sin sucursales',
            subtitle: 'Agrega tu primera sucursal',
          )
        else
          ...sucursales.map((sucursal) => _buildSucursalCard(sucursal)),
      ],
    );
  }

  Widget _buildSucursalCard(Sucursal sucursal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.location_on, color: Colors.blue),
        ),
        title: Text(
          sucursal.direccion,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sucursal.celular != null && sucursal.celular!.isNotEmpty)
              Text(sucursal.celular!),
            if (sucursal.latitud != null && sucursal.longitud != null)
              Text(
                '${sucursal.latitud!.toStringAsFixed(4)}, ${sucursal.longitud!.toStringAsFixed(4)}',
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showSucursalOptions(sucursal);
          },
        ),
        onTap: () {
          _showSucursalDetails(sucursal);
        },
      ),
    );
  }

  // Sección de productos
  Widget _buildProductosSection(List<Producto> productos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Productos', style: AppTextStyles.h3),
            TextButton.icon(
              onPressed: () {
                _addProducto();
              },
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (productos.isEmpty)
          _buildEmptySection(
            icon: Icons.inventory_2,
            title: 'Sin productos',
            subtitle: 'Agrega productos a tu negocio',
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return _buildProductoCard(productos[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductoCard(Producto producto) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: producto.imagen != null && producto.imagen!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          producto.imagen!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.inventory_2, size: 40);
                          },
                        ),
                      )
                    : const Icon(Icons.inventory_2, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sección de usuarios
  Widget _buildUsuariosSection(List<UsuarioNegocio> usuarios) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Usuarios', style: AppTextStyles.h3),
            TextButton.icon(
              onPressed: () {
                _addUsuario();
              },
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (usuarios.isEmpty)
          _buildEmptySection(
            icon: Icons.people,
            title: 'Sin usuarios',
            subtitle: 'Agrega usuarios para administrar tu negocio',
          )
        else
          ...usuarios.map((usuario) => _buildUsuarioCard(usuario)),
      ],
    );
  }

  Widget _buildUsuarioCard(UsuarioNegocio usuario) {
    final rolColor = _getRolColor(
      usuario.rol.value,
    ); // Usar .value para obtener el string
    final rolLabel =
        usuario.rol.label; // Usar .label para obtener la etiqueta legible

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rolColor.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: rolColor),
        ),
        title: Text(
          usuario.idUsuario,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          rolLabel.toUpperCase(), // Usar la etiqueta legible
          style: TextStyle(
            fontSize: 12,
            color: rolColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showUsuarioOptions(usuario);
          },
        ),
      ),
    );
  }

  Color _getRolColor(String rol) {
    switch (rol.toLowerCase()) {
      case 'propietario':
        return Colors.orange;
      case 'administrador':
        return Colors.blue;
      case 'empleado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Sección vacía
  Widget _buildEmptySection({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Estados
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar el dashboard', style: AppTextStyles.h2),
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
              onPressed: controller.loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('No se encontró el negocio'));
  }

  // Métodos de acción
  void _showAddMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Añadir al negocio', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.location_on,
              title: 'Nueva sucursal',
              subtitle: 'Agrega una nueva ubicación',
              onTap: () {
                Get.back();
                _addSucursal();
              },
            ),
            _buildActionTile(
              icon: Icons.inventory_2,
              title: 'Nuevo producto',
              subtitle: 'Agrega un producto al catálogo',
              onTap: () {
                Get.back();
                _addProducto();
              },
            ),
            _buildActionTile(
              icon: Icons.person_add,
              title: 'Nuevo usuario',
              subtitle: 'Invita a alguien a administrar',
              onTap: () {
                Get.back();
                _addUsuario();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _addSucursal() {
    Get.toNamed('/business/sucursal/register/${controller.businessId}');
  }

  void _addProducto() {
    Get.toNamed('/business/oferta/select/${controller.businessId}');
  }

  void _addUsuario() {
    Get.toNamed('/business/usuario/register/${controller.businessId}');
  }

  void _showSucursalDetails(Sucursal sucursal) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Detalles de la sucursal', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildDetailRow('Dirección', sucursal.direccion),
            if (sucursal.celular != null)
              _buildDetailRow('Celular', sucursal.celular!),
            if (sucursal.latitud != null)
              _buildDetailRow('Latitud', sucursal.latitud.toString()),
            if (sucursal.longitud != null)
              _buildDetailRow('Longitud', sucursal.longitud.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showSucursalOptions(Sucursal sucursal) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Get.back();
                // Navegar a editar sucursal
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                // Confirmar eliminación
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUsuarioOptions(UsuarioNegocio usuario) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Cambiar rol'),
              onTap: () {
                Get.back();
                // Cambiar rol
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                // Confirmar eliminación
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBusinessSettings() {
    Get.toNamed('/business/edit/${controller.businessId}');
  }
}
