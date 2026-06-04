import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  DioClient._();

  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        queryParameters: {'apiKey': ApiConstants.apiKey},
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ),
      _RetryInterceptor(dio),
    ]);

    return dio;
  }
}

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this.dio);
  final Dio dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          message: 'Connection timed out. Please check your internet.',
        ),
      );
    } else {
      handler.next(err);
    }
  }
}

// ignore: avoid_print
void debugPrint(String message) => print('[DioClient] $message');
