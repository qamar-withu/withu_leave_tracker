enum UserRole {
  employee,
  manager,
  hr,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.employee:
        return 'Employee';
      case UserRole.manager:
        return 'Manager';
      case UserRole.hr:
        return 'HR';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'employee':
        return UserRole.employee;
      case 'manager':
        return UserRole.manager;
      case 'hr':
        return UserRole.hr;
      case 'admin':
        return UserRole.admin;
      default:
        throw ArgumentError('Invalid UserRole: $value');
    }
  }

  String toJson() => name;
}
