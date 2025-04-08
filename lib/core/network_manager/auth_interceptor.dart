import 'package:beton_book/core/constants/global_app_navigator.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["cookie"] = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>().authHeader['cookie'];
    options.headers["Authorization"] = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>().authHeader['Authorization'];
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic here
    }
    handler.next(err);
  }
}
