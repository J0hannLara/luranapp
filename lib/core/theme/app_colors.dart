import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand — tonos cálidos orientados a promociones y ahorro
  static const Color primary = Color(0xFFE65100);
  static const Color primaryLight = Color(0xFFFF833A);
  static const Color primaryDark = Color(0xFFAC1900);

  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryLight = Color(0xFF60AD5E);
  static const Color secondaryDark = Color(0xFF005005);

  static const Color accent = Color(0xFFFFB300);

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Discount badge
  static const Color discountBadge = Color(0xFFE53935);
  static const Color discountBadgeText = Color(0xFFFFFFFF);

  // Light theme surfaces
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF616161);
  static const Color textHintLight = Color(0xFF9E9E9E);

  // Dark theme surfaces
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF3D3D3D);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF757575);

  // Offer type indicators
  static const Color nearExpiration = Color(0xFFE53935);
  static const Color liquidation = Color(0xFF7B1FA2);
  static const Color clearance = Color(0xFF1565C0);
  static const Color specialDiscount = Color(0xFFE65100);
}
