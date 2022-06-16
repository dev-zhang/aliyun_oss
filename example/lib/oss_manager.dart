/*
 * File Created: 2022-06-14 15:58:45
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-14 17:53:25
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:aliyun_oss/aliyun_oss.dart';

class OSSManager {
  OSSManager._internal() {
    _defaultClient = OSSClient(
      endpoint: _endpoint,
      credentialProvider: OSSAuthCredentialProvider(stsTokenUrl: _stsTokenUrl),
    );

    _imgClient = OSSClient(
      endpoint: _imgEndpoint,
      credentialProvider: OSSAuthCredentialProvider(stsTokenUrl: _stsTokenUrl),
    );
  }

  factory OSSManager() => _manager;

  static late final OSSManager _manager = OSSManager._internal();

  late OSSClient _defaultClient;
  late OSSClient _imgClient;

  OSSClient get defaultClient => _defaultClient;
  OSSClient get imgClient => _imgClient;

  final String _stsTokenUrl = 'http://192.168.0.130:10100/sts/getsts';
  final String _endpoint = 'http://oss-cn-shanghai.aliyuncs.com';
  final String _imgEndpoint = 'http://oss-cn-hangzhou.aliyuncs.com';
}
