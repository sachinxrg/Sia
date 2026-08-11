import 'package:intl/intl.dart';

/// Extension methods on DateTime for common operations throughout SIA.
extension DateTimeExtensions on DateTime {
  /// Returns the date formatted as 'YYYY-MM-DD' for SQLite storage.
  String toDateString() => DateFormat('yyyy-MM-dd').format(this);

  /// Returns the time formatted as 'HH:mm' for display and storage.
  String toTimeString() => DateFormat('HH:mm').format(this);

  /// Returns a human-readable relative time string.
  /// e.g., "in 2 hours", "3 days ago", "due tomorrow"
  String toRelativeString() {
    final now = DateTime.now();
    final diff = difference(now);

    if (diff.isNegative) {
      // Past
      final absDiff = diff.abs();
      if (absDiff.inMinutes < 1) return 'just now';
      if (absDiff.inMinutes < 60) return '${absDiff.inMinutes}m ago';
      if (absDiff.inHours < 24) return '${absDiff.inHours}h ago';
      if (absDiff.inDays < 7) return '${absDiff.inDays}d ago';
      return DateFormat('MMM d').format(this);
    } else {
      // Future
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return 'in ${diff.inMinutes}m';
      if (diff.inHours < 24) return 'in ${diff.inHours}h';
      if (diff.inDays == 1) return 'tomorrow';
      if (diff.inDays < 7) return 'in ${diff.inDays} days';
      return DateFormat('MMM d').format(this);
    }
  }

  /// Returns a greeting based on the current time of day.
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Returns the start of the current day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the current day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Returns the start of the current week (Monday).
  DateTime get startOfWeek {
    final daysFromMonday = weekday - DateTime.monday;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Returns the end of the current week (Sunday).
  DateTime get endOfWeek {
    final daysToSunday = DateTime.sunday - weekday;
    return add(Duration(days: daysToSunday)).endOfDay;
  }

  /// Returns the day of week as an uppercase string (MONDAY, TUESDAY, etc.).
  String get dayOfWeekString {
    switch (weekday) {
      case DateTime.monday:
        return 'MONDAY';
      case DateTime.tuesday:
        return 'TUESDAY';
      case DateTime.wednesday:
        return 'WEDNESDAY';
      case DateTime.thursday:
        return 'THURSDAY';
      case DateTime.friday:
        return 'FRIDAY';
      case DateTime.saturday:
        return 'SATURDAY';
      case DateTime.sunday:
        return 'SUNDAY';
      default:
        return 'UNKNOWN';
    }
  }

  /// Whether this date is the same calendar day as another.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns hours remaining until this time from now. Clamps at 0.
  double get hoursRemaining {
    final diff = difference(DateTime.now());
    return diff.isNegative ? 0.0 : diff.inMinutes / 60.0;
  }
}
