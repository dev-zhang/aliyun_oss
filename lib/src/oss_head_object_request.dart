/*
 * File Created: 2022-06-17 16:28:31
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-17 16:34:15
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:aliyun_oss/src/oss_request.dart';

class OSSHeadObjectRequest extends OSSRequest {
  OSSHeadObjectRequest({
    required String endpoint,
    required String bucketName,
    required String objectKey,
    required String httpMethod,
  }) : super(
          endpoint: endpoint,
          bucketName: bucketName,
          objectKey: objectKey,
          httpMethod: httpMethod,
        );
}
