class AppEndpoints {
  // Use 10.0.2.2 for Android Emulator, localhost for Linux/Web/iOS, or your LAN IP
  static const String defaultBaseUrl = 'http://localhost:4000';

  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';
  static const String courses = '/api/courses';
  static const String schedules = '/api/schedules';
  static const String assignments = '/api/assignments';
  static const String attendance = '/api/attendance';
  static const String payments = '/api/payments';
  static const String announcements = '/api/announcements';
  static const String notifications = '/api/notifications';
  static const String notificationStats = '/api/notifications/stats';
  static const String fcmToken = '/api/notifications/fcm-token';

  // Simulation
  static const String simRunCycle = '/api/simulation/run-cycle';
  static const String simCollision = '/api/simulation/trigger-deadline-collision';
  static const String simAttendanceRisk = '/api/simulation/trigger-attendance-risk';
  static const String simUrgentPayment = '/api/simulation/trigger-urgent-payment';
}
