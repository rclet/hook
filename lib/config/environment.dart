enum Environment { dev, staging, prod }

class AppConfig {
  static late Environment _environment;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://gig.com.bd/gig-main/backend/api';
      case Environment.staging:
        return 'https://gig.com.bd/gig-main/backend/api';
      case Environment.prod:
        return 'https://gig.com.bd/gig-main/backend/api';
    }
  }
  
  static bool get isDebug {
    switch (_environment) {
      case Environment.dev:
        return true;
      case Environment.staging:
        return true;
      case Environment.prod:
        return false;
    }
  }
  
  static String get appName {
    switch (_environment) {
      case Environment.dev:
        return 'Pipit Dev';
      case Environment.staging:
        return 'Pipit Staging';
      case Environment.prod:
        return 'Pipit';
    }
  }
  
  static String get firebaseProjectId {
    switch (_environment) {
      case Environment.dev:
        return 'pipit-dev';
      case Environment.staging:
        return 'pipit-staging';
      case Environment.prod:
        return 'pipit-prod';
    }
  }
}