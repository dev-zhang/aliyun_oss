import 'dart:async';
import 'dart:convert';

import 'package:aliyun_oss/src/oss_federation_token.dart';

import 'dio_util.dart';

typedef FederationTokenGetter = Future<OSSFederationToken> Function();

class OSSFederationCredentialProvider {
  OSSFederationCredentialProvider({required this.tokenGetter});

  OSSFederationToken? _cachedToken;
  final FederationTokenGetter tokenGetter;

  Future<OSSFederationToken> getToken() async {
    if (_cachedToken == null) {
      _cachedToken = await tokenGetter();
    } else {
      if (isExpired) {
        _cachedToken = await tokenGetter();
      }
    }
    return _cachedToken!;
  }

  /// 是否已过期
  bool get isExpired {
    if (_cachedToken == null) {
      return true;
    }

    final expirationDate =
        DateTime.parse(_cachedToken!.expirationTimeInGMTFormat);
    final difference = expirationDate.difference(DateTime.now().toUtc());

    /* if this token will be expired after less than 2min, we abort it in case of when request arrived oss server,
               it's expired already. */
    // 剩余时间小于5分钟，则需要刷新
    if (difference.inMinutes <= 5) {
      return true;
    }
    return false;
  }
}

class OSSAuthCredentialProvider extends OSSFederationCredentialProvider {
  OSSAuthCredentialProvider({
    required String stsTokenUrl,
  })  : assert(stsTokenUrl.isNotEmpty),
        super(tokenGetter: () async {
          final dio = DioUtil.getDio()!;
          final res = await dio.get(stsTokenUrl);
          final data = jsonDecode(res.data);
          return OSSFederationToken.fromJson(data);
        });
}
