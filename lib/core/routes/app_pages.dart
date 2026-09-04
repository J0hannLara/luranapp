import 'package:get/get.dart';
import 'package:luranapp/core/routes/app_routes.dart';
import 'package:luranapp/features/auth/presentation/pages/login_page.dart';
import 'package:luranapp/features/auth/presentation/pages/onboarding_page.dart';
import 'package:luranapp/features/auth/presentation/pages/register_page.dart';
import 'package:luranapp/features/auth/presentation/pages/splash_page.dart';
import 'package:luranapp/features/business_dashboard/presentation/bindings/business_dashboard_binding.dart';
import 'package:luranapp/features/business_dashboard/presentation/pages/business_main_shell.dart';
import 'package:luranapp/features/business_dashboard/presentation/pages/businesses_dashboard_page.dart';
import 'package:luranapp/features/businesses/presentation/bindings/business_management_binding.dart';
import 'package:luranapp/features/businesses/presentation/bindings/business_registration_binding.dart';
import 'package:luranapp/features/businesses/presentation/pages/business_registration_page.dart';
import 'package:luranapp/features/businesses/presentation/bindings/business_binding.dart';
import 'package:luranapp/features/businesses/presentation/pages/business_status_page.dart';
import 'package:luranapp/features/businesses/presentation/pages/my_businesses_page.dart';
import 'package:luranapp/features/businesses/presentation/pages/register_sucursal_page.dart';
import 'package:luranapp/features/home/presentation/bindings/home_binding.dart';
import 'package:luranapp/features/home/presentation/pages/customer_main_shell.dart';
import 'package:luranapp/features/home/presentation/pages/home_page.dart';
import 'package:luranapp/features/offer/presentation/bindings/add_offer_binding.dart';
import 'package:luranapp/features/offer/presentation/pages/register_offer_page.dart';
import 'package:luranapp/features/offer/presentation/pages/select_product_page.dart';

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
      binding: BusinessRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.businessStatus,
      page: () => BusinessStatusPage(businessId: Get.parameters['id'] ?? ''),
      binding: BusinessRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.businessRegisterSucursal,
      page: () => const RegisterSucursalPage(),
      binding: BusinessRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.myBusinesses,
      page: () => const MyBusinessesPage(),
      binding: BusinessManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.businessDashboard,
      page: () => BusinessDashboardPage(businessId: Get.parameters['id'] ?? ''),
      binding: BusinessDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.selectProduct,
      page: () => SelectProductPage(),
      binding: AddOfferBinding(),
    ),
    GetPage(
      name: AppRoutes.registerOffer,
      page: () => RegisterOfferPage(),
      binding: AddOfferBinding(),
    ),
  ];
}
