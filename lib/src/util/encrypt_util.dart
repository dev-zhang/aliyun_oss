/*
 * File Created: 2022-06-15 19:02:33
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-16 09:38:21
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

/*
 * File Created: 2022-04-19 14:16:51
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-04-19 15:45:37
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';

class EncryptUtil {
  const EncryptUtil._();

  static String md5Encode(List<int> input) {
    final Digest digest = md5.convert(input);
    return base64.encode(digest.bytes);
  }

  static String base64EncodeSha1(String content, String key) {
    final utf8Key = utf8.encode(key);
    final utf8Content = utf8.encode(content);
    final Hmac hmac = Hmac(sha1, utf8Key);
    final Digest digest = hmac.convert(utf8Content);
    return base64.encode(digest.bytes);
  }

  static String base64Encode(String data) {
    return base64.encode(utf8.encode(data));
  }

  static String base64Decode(String data) {
    return String.fromCharCodes(base64.decode(data));
  }
}
