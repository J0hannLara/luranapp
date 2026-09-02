enum Environment {
  development,
  staging,
  production,
}

class AppEnvironment {
  AppEnvironment._();

  static Environment current = Environment.development;

  static String get apiBaseUrl {
    return switch (current) {
      Environment.development => 'http://localhost:8000/api/v1',
      Environment.staging => 'https://staging-api.ofertalocal.com/api/v1',
      Environment.production => 'https://api.ofertalocal.com/api/v1',
    };
  }

  static bool get isDevelopment => current == Environment.development;
  static bool get isProduction => current == Environment.production;
}
