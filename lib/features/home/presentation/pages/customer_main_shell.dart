import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/features/explore/presentation/pages/explore_page.dart';
import 'package:luranapp/features/favorites/presentation/pages/favorites_page.dart';
import 'package:luranapp/features/home/presentation/controllers/home_controller.dart';
import 'package:luranapp/features/home/presentation/pages/home_page.dart';
import 'package:luranapp/features/orders/presentation/pages/reservations_page.dart';
import 'package:luranapp/features/profile/presentation/pages/profile_page.dart';

class CustomerMainShell extends GetView<HomeController> {
  const CustomerMainShell({super.key});

  static const _pages = <Widget>[
    HomePage(),
    ExplorePage(),
    FavoritesPage(),
    ReservationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentTabIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: AppStrings.navExplore,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: AppStrings.navFavorites,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: AppStrings.navReservations,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: AppStrings.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
