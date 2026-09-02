class PriceHelper {
  PriceHelper._();

  /// Calcula el porcentaje de descuento a partir del precio original y oferta.
  /// Retorna un valor entre 0 y 100, redondeado al entero más cercano.
  static int calculateDiscountPercentage({
    required double originalPrice,
    required double offerPrice,
  }) {
    if (originalPrice <= 0 || offerPrice >= originalPrice) return 0;
    return (((originalPrice - offerPrice) / originalPrice) * 100).round();
  }

  static String formatCurrency(double amount, {String symbol = 'Bs'}) {
    return '$symbol ${amount.toStringAsFixed(2)}';
  }
}
