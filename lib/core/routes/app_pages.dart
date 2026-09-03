import 'package:get/get.dart';
import 'package:luranapp/core/routes/app_routes.dart';
import 'package:luranapp/features/auth/presentation/pages/login_page.dart';
import 'package:luranapp/features/auth/presentation/pages/onboarding_page.dart';
import 'package:luranapp/features/auth/presentation/pages/register_page.dart';
import 'package:luranapp/features/auth/presentation/pages/splash_page.dart';
import 'package:luranapp/features/business_dashboard/presentation/bindings/business_dashboard_binding.dart';
import 'package:luranapp/features/business_dashboard/presentation/pages/business_main_shell.dart';
import 'package:luranapp/features/businesses/presentation/pages/business_registration_page.dart';
import 'package:luranapp/features/businesses/presentation/bindings/business_binding.dart';
import 'package:luranapp/features/businesses/presentation/pages/business_status_page.dart';
import 'package:luranapp/features/home/presentation/bindings/home_binding.dart';
import 'package:luranapp/features/home/presentation/pages/customer_main_shell.dart';
import 'package:luranapp/features/home/presentation/pages/home_page.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingPage()),
    GetPage(
      name: AppRoutes.customerMain,
      page: () => const CustomerMainShell(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.businessMain,
      page: () => const BusinessMainShell(),
      binding: BusinessDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.businessRegister,
      page: () => const RegisterBusinessPage(),
      binding: BusinessBinding(),
    ),
    GetPage(
      name: AppRoutes.businessStatus,
      page: () => BusinessStatusPage(businessId: Get.parameters['id'] ?? ''),
      binding: BusinessBinding(),
    ),
  ];
}
