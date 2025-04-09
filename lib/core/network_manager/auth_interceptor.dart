import 'package:beton_book/core/constants/global_app_navigator.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["cookie"] = GlobalNavigator.navigatorKey.currentContext!
        .read<AppProvider>()
        .authHeader['cookie'];
    options.headers["Authorization"] =
    GlobalNavigator.navigatorKey.currentContext!
        .read<AppProvider>()
        .authHeader['Authorization'];
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    String message;

    try {
      if (err.response != null) {
        print("have response");
        final data = err.response?.data;

        if (data is Map<String, dynamic>) {
          message = '${data['message'] ?? "Something went wrong"}\n\n'
              '${data['error']?['details'] ?? "Try again later"}';

          print(message);
        } else {
          print("Response: $statusCode ${err.response?.data}");
          message = "Server error. Please try again later.";
        }
      } else {
        message = "Something went wrong! Check your internet connection.";
      }
    } catch (_) {
      message = "System error.";
    }
    print("failed message: $message");
    final fakeResponse = Response(
      requestOptions: err.requestOptions,
      data: {
        "success": false,
        "message": message,
      },
      statusCode: 200, // Ensure client receives this as a 'successful' response
    );

    handler.resolve(fakeResponse);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final wrappedResponse = Response(
      requestOptions: response.requestOptions,
      data: {
        "success": true,
        "data": response.data,
      },
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers,
      extra: response.extra,
      redirects: response.redirects,
      isRedirect: response.isRedirect,
    );

    handler.resolve(wrappedResponse);
  }


}
