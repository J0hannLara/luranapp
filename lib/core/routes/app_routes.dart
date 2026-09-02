abstract class AppRoutes {
  AppRoutes._();

  // Splash & Auth
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const onboarding = '/onboarding'; 

  // Main shells
  static const customerMain = '/customer';
  static const businessMain = '/business';

  // Customer tabs
  static const home = '/customer/home';
  static const explore = '/customer/explore';
  static const favorites = '/customer/favorites';
  static const reservations = '/customer/reservations';
  static const profile = '/customer/profile';

  // Business tabs
  static const dashboard = '/business/dashboard';
  static const myOffers = '/business/offers';
  static const businessReservations = '/business/reservations';
  static const statistics = '/business/statistics';
  static const businessProfile = '/business/profile';

  // Shared detail pages
  static const offerDetail = '/offer/:id';
  static const businessDetail = '/business/:id';
  static const notifications = '/notifications';

  // Business management (TODO en fases posteriores)
  static const createOffer = '/business/offers/create';
  static const editOffer = '/business/offers/:id/edit';
}
