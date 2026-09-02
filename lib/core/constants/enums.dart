enum UserRole {
  customer,
  business,
  admin;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.customer,
    );
  }
}

enum OfferType {
  nearExpiration('near_expiration', 'Por vencimiento'),
  liquidation('liquidation', 'Liquidación'),
  clearance('clearance', 'Remate'),
  stock('stock', 'Exceso de stock'),
  seasonal('seasonal', 'Temporada'),
  specialDiscount('special_discount', 'Descuento especial'),
  combo('combo', 'Combo/Pack'),
  other('other', 'Otro');

  const OfferType(this.value, this.label);

  final String value;
  final String label;

  static OfferType fromString(String value) {
    return OfferType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => OfferType.other,
    );
  }
}

enum OfferStatus {
  draft('draft'),
  active('active'),
  reserved('reserved'),
  soldOut('sold_out'),
  expired('expired'),
  cancelled('cancelled');

  const OfferStatus(this.value);

  final String value;

  static OfferStatus fromString(String value) {
    return OfferStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OfferStatus.draft,
    );
  }
}

enum OrderStatus {
  pending('pending'),
  confirmed('confirmed'),
  ready('ready'),
  completed('completed'),
  cancelled('cancelled'),
  expired('expired');

  const OrderStatus(this.value);

  final String value;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

enum FavoriteType {
  offer,
  business,
}

enum NotificationType {
  nearbyOffer,
  favoriteEnding,
  reservationConfirmed,
  reservationCancelled,
  productSoldOut,
  businessPromotion,
}

enum OfferSortOption {
  nearest('Más cercanas'),
  highestDiscount('Mayor descuento'),
  lowestPrice('Menor precio'),
  mostRecent('Más recientes'),
  endingSoon('Por terminar');

  const OfferSortOption(this.label);

  final String label;
}
