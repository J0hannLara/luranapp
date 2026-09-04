// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/core/utils/view_state.dart';
import 'package:luranapp/core/widgets/loading_widget.dart';
import 'package:luranapp/features/offer/domain/entities/oferta.dart';
import 'package:luranapp/features/product/domain/entities/producto.dart';
import 'package:luranapp/features/home/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.viewState == ViewState.loading) {
        return const LoadingWidget();
      }

      if (controller.viewState == ViewState.error) {
        return _buildErrorState();
      }

      return RefreshIndicator(
        onRefresh: controller.loadOfertas,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.nearbyOffers, style: AppTextStyles.h3),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO(FASE 8): Navegar a notificaciones.
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 24),

                    // Secciones con ofertas reales
                    if (controller.nearbyOffers.isNotEmpty) ...[
                      _buildOfferSection(
                        AppStrings.nearbyOffers,
                        controller.nearbyOffers,
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (controller.endingSoon.isNotEmpty) ...[
                      _buildOfferSection(
                        AppStrings.endingSoon,
                        controller.endingSoon,
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (controller.biggestDiscounts.isNotEmpty) ...[
                      _buildOfferSection(
                        AppStrings.biggestDiscounts,
                        controller.biggestDiscounts,
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (controller.nearbyBusinesses.isNotEmpty) ...[
                      _buildOfferSection(
                        AppStrings.nearbyBusinesses,
                        controller.nearbyBusinesses,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Si no hay ofertas
                    if (controller.nearbyOffers.isEmpty &&
                        controller.endingSoon.isEmpty &&
                        controller.biggestDiscounts.isEmpty &&
                        controller.nearbyBusinesses.isEmpty) ...[
                      _buildEmptyState(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      readOnly: true,
      onTap: () {
        Get.toNamed('/explore');
      },
      decoration: InputDecoration(
        hintText: '${AppStrings.search} ofertas...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {
            // TODO(FASE 4): Abrir filtros.
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildOfferSection(String title, List<Oferta> ofertas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.sectionTitle),
            TextButton(
              onPressed: () {
                Get.toNamed('/explore');
              },
              child: const Text(AppStrings.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ofertas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _buildOfferCard(ofertas[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(Oferta oferta) {
    final producto = controller.getProductoById(oferta.idProducto);

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: producto?.imagen != null && producto!.imagen!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        producto.imagen!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildProductPlaceholder();
                        },
                      ),
                    )
                  : _buildProductPlaceholder(),
            ),
          ),

          // Información del producto
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto?.nombre ?? 'Producto',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Precios
                Row(
                  children: [
                    // Precio remate
                    Text(
                      'Bs. ${oferta.precioRemate.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Precio regular tachado
                    Text(
                      'Bs. ${oferta.precioRegular.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Descuento
                if (oferta.porcentajeDescuento != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${oferta.porcentajeDescuento!.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.inventory_2, size: 48, color: Colors.grey),
      ),
    );
  }

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
              'Error al cargar ofertas',
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
              onPressed: controller.loadOfertas,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_offer, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No hay ofertas disponibles',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Vuelve pronto para ver nuevas ofertas',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
