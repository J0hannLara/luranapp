import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/core/utils/view_state.dart';
import 'package:luranapp/core/widgets/loading_widget.dart';
import 'package:luranapp/features/home/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == ViewState.loading) {
        return const LoadingWidget();
      }

      return CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.nearbyOffers,
                  style: AppTextStyles.h3,
                ),
                Text(
                  'Ubicación actual (demo)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                  ),
                ),
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
                  _buildPlaceholderSection(AppStrings.nearbyOffers),
                  const SizedBox(height: 24),
                  _buildPlaceholderSection(AppStrings.endingSoon),
                  const SizedBox(height: 24),
                  _buildPlaceholderSection(AppStrings.biggestDiscounts),
                  const SizedBox(height: 24),
                  _buildPlaceholderSection(AppStrings.nearbyBusinesses),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      readOnly: true,
      onTap: () {
        // TODO(FASE 4): Navegar a búsqueda/explorar.
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
      ),
    );
  }

  Widget _buildPlaceholderSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.sectionTitle),
            TextButton(
              onPressed: () {},
              child: const Text(AppStrings.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _buildPlaceholderCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCard(int index) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Oferta ${index + 1}\n(FASE 4)',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}
