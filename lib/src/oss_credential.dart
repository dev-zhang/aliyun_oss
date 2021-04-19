class OSSCredential {
  final String? accessKeyId;
  final String? accessKeySecret;
  final String? securityToken;
  final String? expiration;

  OSSCredential({
    this.accessKeyId,
    this.accessKeySecret,
    this.securityToken,
    this.expiration,
  });
}
