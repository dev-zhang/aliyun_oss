part of aliyun_oss;

class OSSClient {
  OSSClient({
    required this.endpoint,
    required this.credentialProvider,
    this.configuration = const OSSConfiguration(),
  }) : assert(endpoint.isNotEmpty) {
    _dio = Dio(BaseOptions(
      connectTimeout: configuration.connectTimeout.inMilliseconds,
      receiveTimeout: configuration.receiveTimeout.inMilliseconds,
      sendTimeout: configuration.sendTimeout.inMilliseconds,
    ));
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }

  final OSSConfiguration configuration;

  final String endpoint;
  final OSSFederationCredentialProvider credentialProvider;

  /// Endpoint url that start with http or https
  ///
  /// eg. https://oss-cn-shanghai.aliyuncs.com
  String get endpointUrl {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return 'https://' + endpoint;
  }

  /// The corresponding RESTFul API: GetService
  /// Gets all the buckets of the current user
  Future<Object> getService() async {
    throw UnimplementedError();
  }

  late final Dio _dio;
  late final Signer _signer = Signer(credentialProvider);
}
