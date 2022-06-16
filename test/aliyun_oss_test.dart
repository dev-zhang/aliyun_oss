import 'dart:io';

import 'package:aliyun_oss/aliyun_oss.dart';
import 'package:aliyun_oss/src/dio_util.dart';
import 'package:aliyun_oss/src/oss_federation_token.dart';
import 'package:test/test.dart';

void main() {
  final OSSFederationCredentialProvider _provider =
      OSSFederationCredentialProvider(
    tokenGetter: () async {
      final dio = DioUtil.getDio()!;
      final params = <String, dynamic>{};
      params['session_name'] = 'roleSessionName';
      final r =
          await dio.post('http://192.168.0.130:10100/sts/getsts', data: params);
      return OSSFederationToken.fromJson(r.data);
    },
  );
  final OSSClient _client = OSSClient(
    endpoint: 'oss-cn-shanghai.aliyuncs.com',
    credentialProvider: _provider,
  );

  test('test client', () async {
    File file = File('xx/Pictures/redmi-note7.jpg');
    final bytes = await file.readAsBytes();
    _client.postObjectWithBytes(bytes, 'bucket_name', 'redmi-note7.jpg');
  });
}
