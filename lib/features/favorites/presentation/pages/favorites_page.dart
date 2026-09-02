import 'package:flutter/material.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/widgets/empty_state_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navFavorites)),
      body: const EmptyStateWidget(
        title: 'Sin favoritos',
        message: 'Guarda ofertas y negocios para verlos aquí. (FASE 6)',
        icon: Icons.favorite_outline,
      ),
    );
  }
}
