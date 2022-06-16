/*
 * File Created: 2022-06-15 16:06:43
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-15 16:29:30
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

class OSSConfiguration {
  const OSSConfiguration({
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.userAgentMark,
  });

  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final String? userAgentMark;
}
