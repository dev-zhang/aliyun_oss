import 'dart:async';
import 'dart:io';

import 'package:aliyun_oss/src/oss_credential.dart';

typedef FederationCredentialFetcher = Future<Map<String, dynamic>?> Function(
    String authServerUrl);

class OSSAuthCredentialProvider {
  OSSAuthCredentialProvider.init({
    required String authServerUrl,
    required FederationCredentialFetcher fetcher,
  })   : assert(authServerUrl.isNotEmpty),
        _authServerUrl = authServerUrl,
        _fetcher = fetcher;

  final String _authServerUrl;
  final FederationCredentialFetcher _fetcher;

  OSSCredential? _cachedCredential;

  Future<OSSCredential> getCredential() async {
    OSSCredential? validCredential;
    if (_cachedCredential == null) {
      _cachedCredential = await _fetchCredential();
    } else {
      if (_checkExpire(_cachedCredential!.expiration)) {
        _cachedCredential = await _fetchCredential();
      }
    }
    validCredential = _cachedCredential;
    if (validCredential == null) {
      return Future.error(HttpException('获取sts token失败'));
    }
    return validCredential;
  }

  Future<OSSCredential> _fetchCredential() async {
    final Map<String, dynamic> json =
        await (_fetcher(_authServerUrl) as FutureOr<Map<String, dynamic>>);

    // FIXME: 测试
    final expiration = json['Expiration'].replaceAll(' UTC', '');
    OSSCredential credential = OSSCredential(
      accessKeyId: json['AccessKeyId'],
      accessKeySecret: json['AccessKeySecret'],
      securityToken: json['SecurityToken'],
      expiration: expiration,
    );
    return credential;
  }

  // 检查是否过期
  bool _checkExpire(String? expiration) {
    if (expiration?.isEmpty ?? true) {
      return false;
    }
    final expirationDate = DateTime.parse(expiration!);
    final difference = expirationDate.difference(DateTime.now().toUtc());

    // 剩余时间小于两分钟，则需要刷新
    if (difference.inMinutes <= 2) {
      return true;
    }
    return false;
  }
}
