enum LeaveRequestType { annual, sick, casual, maternity, paternity, emergency }

extension LeaveRequestTypeExtension on LeaveRequestType {
  String get value {
    switch (this) {
      case LeaveRequestType.annual:
        return 'annual';
      case LeaveRequestType.sick:
        return 'sick';
      case LeaveRequestType.casual:
        return 'casual';
      case LeaveRequestType.maternity:
        return 'maternity';
      case LeaveRequestType.paternity:
        return 'paternity';
      case LeaveRequestType.emergency:
        return 'emergency';
    }
  }

  static LeaveRequestType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'annual':
        return LeaveRequestType.annual;
      case 'sick':
        return LeaveRequestType.sick;
      case 'casual':
        return LeaveRequestType.casual;
      case 'maternity':
        return LeaveRequestType.maternity;
      case 'paternity':
        return LeaveRequestType.paternity;
      case 'emergency':
        return LeaveRequestType.emergency;
      default:
        return LeaveRequestType.annual;
    }
  }
}
