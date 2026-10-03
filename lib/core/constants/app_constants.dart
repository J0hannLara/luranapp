class AppConstants {
  AppConstants._();

  static const String appName = 'RematesYa';
  static const String appTagline = 'Encuentra ofertas antes de que se acaben.';

  static const int defaultPageSize = 20;
  static const double defaultSearchRadiusKm = 10.0;

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheExpiration = Duration(hours: 24);
}
