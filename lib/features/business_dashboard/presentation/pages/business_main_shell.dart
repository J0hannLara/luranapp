import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/core/widgets/empty_state_widget.dart';
import 'package:luranapp/features/business_dashboard/presentation/controllers/business_dashboard_controller.dart';
import 'package:luranapp/features/profile/presentation/pages/profile_page.dart';

class BusinessMainShell extends GetView<BusinessDashboardController> {
  const BusinessMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _DashboardPage(),
      const _MyOffersPage(),
      const _BusinessReservationsPage(),
      const _StatisticsPage(),
      const ProfilePage(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentTabIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: AppStrings.navDashboard,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer),
              label: AppStrings.navMyOffers,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: AppStrings.navReservations,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: AppStrings.navStatistics,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: AppStrings.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navDashboard)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel de negocio', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Gestiona ofertas, reservas y estadísticas. (FASE 9)',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _StatCard(title: 'Ofertas activas', value: '—'),
                  _StatCard(title: 'Reservas pendientes', value: '—'),
                  _StatCard(title: 'Productos agotados', value: '—'),
                  _StatCard(title: 'Ventas del mes', value: '—'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h2),
          ],
        ),
      ),
    );
  }
}

class _MyOffersPage extends StatelessWidget {
  const _MyOffersPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navMyOffers)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO(FASE 9): Crear oferta.
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva oferta'),
      ),
      body: const EmptyStateWidget(
        title: 'Sin ofertas publicadas',
        message: 'Crea tu primera oferta para empezar. (FASE 9)',
        icon: Icons.local_offer_outlined,
      ),
    );
  }
}

class _BusinessReservationsPage extends StatelessWidget {
  const _BusinessReservationsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navReservations)),
      body: const EmptyStateWidget(
        title: 'Sin reservas',
        message: 'Las reservas de clientes aparecerán aquí. (FASE 7/9)',
        icon: Icons.receipt_long_outlined,
      ),
    );
  }
}

class _StatisticsPage extends StatelessWidget {
  const _StatisticsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navStatistics)),
      body: const EmptyStateWidget(
        title: 'Estadísticas',
        message: 'Métricas y reportes se implementarán en FASE 9.',
        icon: Icons.bar_chart_outlined,
      ),
    );
  }
}
