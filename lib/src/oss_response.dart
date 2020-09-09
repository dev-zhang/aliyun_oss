import 'dart:io';

class OSSResponse {
  OSSResponse(
    this.statusCode,
    this.statusMessage,
  );
  int statusCode;
  String statusMessage;

  bool get isSuccess => statusCode == HttpStatus.ok;

  @override
  String toString() {
    return 'statusCode: $statusCode, statusMessage: $statusMessage';
  }
}
