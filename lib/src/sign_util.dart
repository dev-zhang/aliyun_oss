import 'dart:convert';

import 'package:crypto/crypto.dart';

class SignUtil {
  //验证文本域
  static String policyText =
      '{"expiration": "2099-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

  static String getBase64Policy() {
    assert(policyText.isNotEmpty);
    //进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);

    //进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);
    return policyBase64;
  }

  static String getSignature(String accessKeySecret) {
    assert(accessKeySecret.isNotEmpty);
    final base64Policy = getBase64Policy();
    //再次进行utf8编码
    List<int> policy = utf8.encode(base64Policy);

    //进行utf8 编码
    List<int> utf8AccessKeySecret = utf8.encode(accessKeySecret);

    //通过hmac,使用sha1进行加密
    List<int> signaturePre =
        Hmac(sha1, utf8AccessKeySecret).convert(policy).bytes;

    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    return signature;
  }
}
