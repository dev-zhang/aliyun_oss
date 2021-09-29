import 'package:dio/dio.dart';

class DioUtil {
  static Dio? _dio;
  static Dio? getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(),
      );

      // 配置代理
      // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      //     (client) {
      //   // config the http client
      //   client.findProxy = (uri) {
      //     //proxy all request to localhost:8888
      //     return "PROXY localhost:8888";
      //   };
      //   // you can also create a HttpClient to dio
      //   // return HttpClient();
      // };

      const kReleaseMode =
          bool.fromEnvironment('dart.vm.product', defaultValue: false);
      const bool kProfileMode =
          bool.fromEnvironment('dart.vm.profile', defaultValue: false);

      _dio!.interceptors.addAll([
        if (!kReleaseMode && !kProfileMode)
          LogInterceptor(responseBody: true, requestBody: true),
      ]);
    }
    return _dio;
  }
}
