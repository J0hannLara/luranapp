import 'package:flutter/material.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/widgets/empty_state_widget.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navExplore)),
      body: const EmptyStateWidget(
        title: 'Explorar ofertas',
        message: 'Búsqueda, filtros y categorías se implementarán en FASE 4.',
        icon: Icons.explore_outlined,
      ),
    );
  }
}
