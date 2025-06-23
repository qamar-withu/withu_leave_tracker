class Config {
  static const String appName = 'Withu Leave Tracker';
  
  // Firebase configurations for different flavors
  static const Map<String, FirebaseConfig> firebaseConfigs = {
    'dev': FirebaseConfig(
      projectId: 'withu-leave-tracker-dev',
      apiKey: 'your-dev-api-key',
      appId: 'your-dev-app-id',
    ),
    'qa': FirebaseConfig(
      projectId: 'withu-leave-tracker-qa',
      apiKey: 'your-qa-api-key',
      appId: 'your-qa-app-id',
    ),
    'staging': FirebaseConfig(
      projectId: 'withu-leave-tracker-staging',
      apiKey: 'your-staging-api-key',
      appId: 'your-staging-app-id',
    ),
    'prod': FirebaseConfig(
      projectId: 'withu-leave-tracker-prod',
      apiKey: 'your-prod-api-key',
      appId: 'your-prod-app-id',
    ),
  };

  static String get flavor => const String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  
  static FirebaseConfig get firebaseConfig => firebaseConfigs[flavor]!;
}

class FirebaseConfig {
  final String projectId;
  final String apiKey;
  final String appId;

  const FirebaseConfig({
    required this.projectId,
    required this.apiKey,
    required this.appId,
  });
}
