/*
 * File Created: 2022-06-14 15:27:27
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-14 15:46:51
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

/// FederationToken
class OSSFederationToken {
  OSSFederationToken({
    required this.accessKey,
    required this.secretKey,
    required this.token,
    required this.expirationTimeInGMTFormat,
  });

  final String accessKey;
  final String secretKey;
  final String token;
  final String expirationTimeInGMTFormat;

  factory OSSFederationToken.fromJson(Map<String, dynamic> json) {
    return OSSFederationToken(
      accessKey: json['AccessKeyId'],
      secretKey: json['AccessKeySecret'],
      token: json['SecurityToken'],
      expirationTimeInGMTFormat: json['Expiration'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'AccessKeyId': accessKey,
      'AccessKeySecret': accessKey,
      'SecurityToken': token,
      'Expiration': expirationTimeInGMTFormat,
    };
  }

  @override
  String toString() {
    return '$runtimeType:{AccessKeyId: $accessKey\nAccessKeySecret: $secretKey\nSecurityToken: $token\nExpiration: $expirationTimeInGMTFormat}';
  }
}
