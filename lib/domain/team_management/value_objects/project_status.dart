enum ProjectStatus {
  active,
  inactive,
  completed;

  String get displayName {
    switch (this) {
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.inactive:
        return 'Inactive';
      case ProjectStatus.completed:
        return 'Completed';
    }
  }

  static ProjectStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ProjectStatus.active;
      case 'inactive':
        return ProjectStatus.inactive;
      case 'completed':
        return ProjectStatus.completed;
      default:
        throw ArgumentError('Invalid ProjectStatus: $value');
    }
  }

  String toJson() => name;
}
