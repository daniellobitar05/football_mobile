import 'package:flutter/material.dart';

/// App theme constants
class AppColors {
  // Primary Colors
  static const primaryBlue = Color(0xFF1976D2);
  static const primaryGreen = Color(0xFF4CAF50);
  static const primaryRed = Color(0xFFFF6B6B);
  static const primaryOrange = Color(0xFFFF9800);

  // Background Colors
  static const lightBackground = Color(0xFFF5F5F5);
  static const darkBackground = Color(0xFF121212);

  // Text Colors
  static const darkText = Color(0xFF212121);
  static const lightText = Color(0xFFFFFFFF);
  static const greyText = Color(0xFF757575);

  // Live Match Colors
  static const liveGreen = Color(0xFF4CAF50);
  static const scheduleBlue = Color(0xFF2196F3);
  static const finishedGrey = Color(0xFF9E9E9E);
}

/// Status badge colors based on match status
Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'LIVE':
      return Colors.red;
    case 'FINISHED':
      return Colors.grey;
    case 'SCHEDULED':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

/// Status badge text
String getStatusText(String status) {
  switch (status.toUpperCase()) {
    case 'LIVE':
      return '🔴 LIVE';
    case 'FINISHED':
      return '✅ FINISHED';
    case 'SCHEDULED':
      return '📅 SCHEDULED';
    default:
      return status;
  }
}
