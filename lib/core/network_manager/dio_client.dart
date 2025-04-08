import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        // baseUrl: "https://salary-book.onrender.com/api",
        baseUrl: "http://192.168.0.105:1327/api",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(dio),
      LoggingInterceptor(),
    ]);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(path, queryParameters: queryParams);
  }
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await dio.post(path, data: data);
  }
}
