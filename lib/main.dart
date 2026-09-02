import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/config/dependencies/initial_binding.dart';
import 'package:luranapp/core/constants/app_constants.dart';
import 'package:luranapp/core/database/supabase_client.dart';
import 'package:luranapp/core/routes/app_pages.dart';
import 'package:luranapp/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase antes de ejecutar la app
  await SupabaseClientService.initialize();
  
  runApp(const OfertaLocalApp());
}

class OfertaLocalApp extends StatelessWidget {
  const OfertaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}