import 'dart:convert';
import 'dart:io';

import 'package:aliyun_oss/src/dio_util.dart';
import 'package:aliyun_oss/src/oss_client.dart';
import 'package:aliyun_oss/src/oss_credential_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final OSSAuthCredentialProvider _provider = OSSAuthCredentialProvider.init(
    authServerUrl: 'https://xxx/getStsToken',
    fetcher: (authServerUrl) async {
      final dio = DioUtil.getDio()!;
      final r = await dio.post('https://xx/getStsToken');
      return jsonDecode(r.data);
    },
  );
  final OSSClient _client = OSSClient(
    endpoint: 'oss-cn-shanghai.aliyuncs.com',
    credentialProvider: _provider,
  );

  test('test client', () async {
    File file = File('xx/Pictures/redmi-note7.jpg');
    final bytes = await file.readAsBytes();
    _client.postObject(bytes, 'bucket_name', 'redmi-note7.jpg');
  });
}
