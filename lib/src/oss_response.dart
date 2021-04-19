import 'dart:io';

class OSSResponse {
  OSSResponse(
    this.statusCode,
    this.statusMessage,
    this.fileKey,
  );

  int? statusCode;
  String? statusMessage;

  /// OSS存储的Object的key
  String fileKey;

  bool get isSuccess => statusCode == HttpStatus.ok;

  @override
  String toString() {
    return 'statusCode: $statusCode, statusMessage: $statusMessage, fileKey: $fileKey';
  }
}
