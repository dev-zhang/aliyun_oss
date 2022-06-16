/*
 * File Created: 2022-06-14 13:59:09
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-14 14:14:10
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:aliyun_oss/aliyun_oss.dart';

/// **Bucket**的相关操作方法
extension OSSClientBucket on OSSClient {
  /// The corresponding RESTFul API: PutBucket
  Future<Object> createBucket() async {
    throw UnimplementedError();
  }

  /// The corresponding RESTFul API: DeleteBucket
  Future<Object> deleteBucket() async {
    throw UnimplementedError();
  }

  /// The corresponding RESTFul API: GetBucket
  Future<Object> getBucket() async {
    throw UnimplementedError();
  }

  /// The corresponding RESTFul API: GetBucketInfo
  Future<Object> getBucketInfo() async {
    throw UnimplementedError();
  }

  /// The corresponding RESTFul API: GetBucketACL
  Future<Object> getBucketACL() async {
    throw UnimplementedError();
  }
}
