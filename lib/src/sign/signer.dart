/*
 * File Created: 2022-06-15 16:04:28
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-16 10:35:52
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:aliyun_oss/src/oss_federation_token.dart';
import 'package:aliyun_oss/src/oss_request.dart';
import 'package:aliyun_oss/src/util/encrypt_util.dart';

import '../oss_credential_provider.dart';

class Signer {
  Signer(this.credentialProvider);

  final OSSFederationCredentialProvider credentialProvider;

  Future<OSSRequest> sign(OSSRequest request) async {
    final federationToken = await credentialProvider.getToken();
    request.headers['content-md5'] = request.contentMd5;
    request.headers['content-type'] = request.contentType;
    request.headers['x-oss-security-token'] = federationToken.token;
    request.headers['date'] = request.httpDate;
    final stringToSign = _stringToSign(request);
    final signature = _sign(stringToSign, federationToken);
    request.headers['Authorization'] = signature;
    return request;
  }

  String _sign(String content, OSSFederationToken token) {
    final signature = EncryptUtil.base64EncodeSha1(content, token.secretKey);
    return 'OSS ${token.accessKey}:$signature';
  }

  String _stringToSign(OSSRequest request) {
    final String contentMd5 = request.headers['content-md5'] ?? '';
    final String contentType = request.headers['content-type'] ?? '';
    final String date = request.headers['date'] ?? '';
    final String headers = _getHeaderString(request);
    final String resourceString = _getResourceString(request);
    return [
      request.httpMethod,
      contentMd5,
      contentType,
      date,
      headers,
      resourceString,
    ].join('\n');
  }

  String _getHeaderString(OSSRequest request) {
    final headerKeys = request.headers.keys
        .where((key) => key.toLowerCase().startsWith('x-oss'))
        .toList();
    if (headerKeys.isEmpty) {
      return '';
    }
    headerKeys.sort((a, b) => a.compareTo(b));
    final headers = headerKeys.map((key) => '$key:${request.headers[key]}');
    return headers.join('\n');
  }

  String _getResourceString(OSSRequest request) {
    String path = '/';
    if (request.bucketName.isNotEmpty) {
      path += '${request.bucketName}/';
    }
    if (request.objectKey.isNotEmpty) {
      path += request.objectKey;
    }
    return path;
  }
}
