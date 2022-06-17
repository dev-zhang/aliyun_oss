/*
 * File Created: 2022-06-15 16:04:28
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-17 16:06:29
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:aliyun_oss/src/oss_federation_token.dart';
import 'package:aliyun_oss/src/oss_request.dart';
import 'package:aliyun_oss/src/util/encrypt_util.dart';

import '../oss_credential_provider.dart';

class Signer {
  Signer(this.credentialProvider);

  final OSSFederationCredentialProvider credentialProvider;

  static const List<String> _ossSubResourceKeys = [
    'acl',
    'uploadId',
    'partNumber',
    'uploads',
    'logging',
    'website',
    'location',
    'lifecycle',
    'referer',
    'cors',
    'delete',
    'append',
    'position',
    'security-token',
    'x-oss-process',
    'sequential',
    'bucketInfo',
    'symlink',
    'restore',
  ];

  Future<OSSRequest> sign(OSSRequest request) async {
    final federationToken = await credentialProvider.getToken();
    request.headers['Content-MD5'] = request.contentMd5;
    request.headers['Content-Type'] = request.contentType;
    request.headers['x-oss-security-token'] = federationToken.token;
    request.headers['Date'] = request.httpDate;
    request.headers['Host'] = request.host;
    final stringToSign = _stringToSign(request);
    final authorization = _sign(stringToSign, federationToken);
    request.headers['Authorization'] = authorization;
    return request;
  }

  String _sign(String content, OSSFederationToken token) {
    final signature = EncryptUtil.base64EncodeSha1(content, token.secretKey);
    return 'OSS ${token.accessKey}:$signature';
  }

  String _stringToSign(OSSRequest request) {
    final String contentMd5 = request.headers['Content-MD5'] ?? '';
    final String contentType = request.headers['Content-Type'] ?? '';
    final String date = request.headers['Date'] ?? '';
    final String ossHeaders = _constructCanonicalizedOSSHeaders(request);
    final String resource = _constructCanonicalizedResource(request);
    print('''=====string to sign:
        httpMethod:${request.httpMethod}
        Content-MD5:$contentMd5
        ContentType:$contentType
        Date:$date
        CanonicalizedOSSHeader:$ossHeaders
        CanonicalizedResource:$resource
        ''');
    return [
      request.httpMethod,
      contentMd5,
      contentType,
      date,
      ossHeaders,
      resource,
    ].join('\n');
  }

  String _constructCanonicalizedOSSHeaders(OSSRequest request) {
    final headerKeys = request.headers.keys
        .where((key) => key.toLowerCase().startsWith('x-oss'))
        .toList();
    if (headerKeys.isEmpty) {
      return '';
    }
    headerKeys.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final headers = headerKeys.map((key) {
      // 删除头尾空格
      final tKey = key.trim().toLowerCase();
      var tValue = request.headers[key];
      if (tValue is String) {
        tValue = tValue.trim();
      }
      return '$tKey:$tValue';
    });
    return headers.join('\n');
  }

  String _constructCanonicalizedResource(OSSRequest request) {
    String resource = '/';
    if (request.bucketName.isNotEmpty) {
      resource = '/${request.bucketName}/';
    }
    if (request.objectKey.isNotEmpty) {
      resource += request.objectKey;
    }

    if (request.params.isNotEmpty) {
      final querys = <String>[];
      final subResourceKeys = request.params.keys
          .where((key) => _ossSubResourceKeys.contains(key.toLowerCase()))
          .toList();
      subResourceKeys
          .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      for (final key in subResourceKeys) {
        final value = request.params[key];
        final tKey = key.toLowerCase();
        if (value is String && value.isEmpty) {
          querys.add(tKey);
        } else {
          querys.add('$tKey=$value');
        }
      }
      if (querys.isNotEmpty) {
        resource += '?';
        resource += querys.join('&');
      }
    }
    return resource;
  }
}
