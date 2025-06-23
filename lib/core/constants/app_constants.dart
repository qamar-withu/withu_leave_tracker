class AppConstants {
  // App Info
  static const String appName = 'Withu Leave Tracker';
  static const String appVersion = '1.0.0';

  // Collections
  static const String usersCollection = 'users';
  static const String projectsCollection = 'projects';
  static const String teamsCollection = 'teams';
  static const String leaveRequestsCollection = 'leave_requests';

  // Leave Types
  static const List<String> leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Maternity Leave',
    'Paternity Leave',
    'Emergency Leave',
    'Casual Leave',
    'Study Leave',
  ];

  // Leave Status
  static const List<String> leaveStatus = [
    'Pending',
    'Approved',
    'Rejected',
    'Cancelled',
  ];

  // User Roles
  static const String adminRole = 'admin';
  static const String managerRole = 'manager';
  static const String employeeRole = 'employee';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // API Endpoints
  static const String baseUrl = 'https://api.withuleavetracker.com';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String projectsEndpoint = '/projects';
  static const String leaveRequestsEndpoint = '/leave-requests';
}
