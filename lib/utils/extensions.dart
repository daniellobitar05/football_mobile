import 'package:intl/intl.dart';

/// String extensions for formatting
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Convert status to display text
  String toStatusDisplay() {
    switch (toUpperCase()) {
      case 'LIVE':
        return '🔴 LIVE';
      case 'FINISHED':
        return '✅ FINISHED';
      case 'SCHEDULED':
      case 'TIMED':
        return '📅 SCHEDULED';
      default:
        return capitalize();
    }
  }
}

/// DateTime extensions for formatting
extension DateTimeExtensions on DateTime {
  /// Format as time only (HH:mm)
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format as date only (MMM d, yyyy)
  String toDateString() {
    return DateFormat('MMM d, yyyy').format(this);
  }

  /// Format as full datetime (HH:mm, MMM d, yyyy)
  String toFullString() {
    return DateFormat('HH:mm, MMM d, yyyy').format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get relative date string (Today, Tomorrow, etc.)
  String toRelativeDateString() {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    return toDateString();
  }
}
