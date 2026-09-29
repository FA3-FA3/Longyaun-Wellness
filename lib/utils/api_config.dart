import 'package:flutter/foundation.dart';

/// Supply API_BASE_URL when building the deployed frontend.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kDebugMode ? 'http://localhost:8080' : '',
  );
}
