/*
 * File Created: 2022-06-15 18:30:24
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-15 18:46:26
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:typed_data';

import 'package:mime/mime.dart';

class OSSUtil {
  const OSSUtil._();

  static const String defaultContentType = 'application/octet-stream';

  static String determineMimeType({
    String? filePath,
    Uint8List? fileBytes,
    String? objectKey,
  }) {
    String? type;
    if ((filePath?.isNotEmpty ?? false) || (fileBytes?.isNotEmpty ?? false)) {
      type = lookupMimeType(filePath!, headerBytes: fileBytes);
    }
    if ((type?.isEmpty ?? true) && (objectKey?.isNotEmpty ?? false)) {
      type = lookupMimeType(objectKey!);
    }

    type ??= defaultContentType;
    return type;
  }
}
