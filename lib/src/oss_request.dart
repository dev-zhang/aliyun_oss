/*
 * File Created: 2022-06-15 16:38:56
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-16 10:24:12
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:aliyun_oss/src/object_acl.dart';
import 'package:aliyun_oss/src/util/encrypt_util.dart';
import 'package:aliyun_oss/src/util/oss_util.dart';

const String defaultContentType = 'application/octet-stream';

class OSSRequest {
  OSSRequest({
    required this.endpoint,
    required this.bucketName,
    required this.objectKey,
    required this.httpMethod,
    this.acl = ObjectACL.inherited,
    this.contentType = defaultContentType,
    this.contentMd5 = '',
    this.file,
    this.fileBytes,
    Map<String, dynamic>? headers,
  })  : headers = headers ?? <String, dynamic>{},
        assert(file != null || fileBytes != null) {
    if (httpMethod == 'PUT' || httpMethod == 'POST') {
      contentType = OSSUtil.determineMimeType(
        filePath: file?.path,
        fileBytes: fileBytes,
        objectKey: objectKey,
      );
    }
    _date = DateTime.now();
    if (contentMd5.isEmpty && (file != null || fileBytes != null)) {
      contentMd5 = _calculateFileMd5(file: file, fileBytes: fileBytes);
    }
  }

  final String endpoint;
  final String bucketName;
  final String objectKey;

  ObjectACL acl;

  String httpMethod;
  String contentType = defaultContentType;
  String contentMd5;
  late DateTime _date;

  String get httpDate => HttpDate.format(_date);

  final File? file;
  final Uint8List? fileBytes;

  Map<String, dynamic> headers;

  String get fullUrl => _fullUri.toString();

  String get url => '$fullUrl/$objectKey';

  String get host => _fullUri.host;

  String get _endpointUrl =>
      endpoint.startsWith('http') ? endpoint : 'https://$endpoint';

  Uri get _endpointUri => Uri.tryParse(_endpointUrl)!;

  Uri get _fullUri {
    final uri = _endpointUri;
    final host = '$bucketName.${uri.host}';
    final fullUri = uri.replace(host: host);
    return fullUri;
  }

  String _calculateFileMd5({File? file, Uint8List? fileBytes}) {
    Uint8List? bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    }
    if (bytes == null && file != null && file.existsSync()) {
      bytes = file.readAsBytesSync();
    }
    if (bytes == null) {
      return '';
    }
    return EncryptUtil.md5Encode(bytes);
  }
}
