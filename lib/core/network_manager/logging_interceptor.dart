import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("\n\n➡️ Request: ${options.method} ${options.uri}");
    print("➡️ Body: ${options.data}");
    print("Headers: ${options.headers}\n\n");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ Response: ${response.statusCode} ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ Error: ${err.message}");
    handler.next(err);
  }
}
