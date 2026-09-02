import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navProfile)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 48),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                controller.currentUser.value?.username ?? 'Usuario',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Obx(
              () => Text(
                controller.currentUser.value?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.signOut,
                icon: const Icon(Icons.logout),
                label: const Text(AppStrings.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
