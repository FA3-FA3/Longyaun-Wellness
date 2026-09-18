/// Cloud Run service base URL. Points at the local dev server for now —
/// swap this to the deployed Cloud Run URL once that exists.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://localhost:8080';
}
