import 'package:flutter/material.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/widgets/empty_state_widget.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navReservations)),
      body: const EmptyStateWidget(
        title: 'Sin reservas',
        message: 'Tus reservas y recogidas aparecerán aquí. (FASE 7)',
        icon: Icons.receipt_long_outlined,
      ),
    );
  }
}
