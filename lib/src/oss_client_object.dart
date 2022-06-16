/*
 * File Created: 2022-06-14 14:03:05
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-16 10:35:42
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

part of aliyun_oss;

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:aliyun_oss/aliyun_oss.dart';
// import 'package:aliyun_oss/src/oss_federation_token.dart';
// import 'package:dio/dio.dart';

// import 'dio_util.dart';

/// **Object**相关的操作方法
extension OSSClientObject on OSSClient {
  Future<OSSResponse> postObjectWithBytes(
    Uint8List fileData,
    String bucketName,
    String fileKey, {
    ObjectACL acl = ObjectACL.inherited,
  }) async {
    final OSSFederationToken token = await credentialProvider.getToken();

    FormData formData = FormData.fromMap({
      //文件名，随意
      'Filename': fileKey,
      //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'key': fileKey, //上传后的文件名
      'policy': SignUtil.getBase64Policy(),
      //Bucket 拥有者的AccessKeyId。
      //  accessKeyId 大小写 和服务端返回的对应就成，不要在意这些细节  下同
      'OSSAccessKeyId': token.accessKey,
      //让服务端返回200，不然，默认会返回204
      'success_action_status': '200',
      'signature': SignUtil.getSignature(token.secretKey),
      //临时用户授权时必须，需要携带后台返回的security-token
      'x-oss-security-token': token.token,
      // 指定OSS创建Object时的访问权限
      'x-oss-object-acl': acl.parameter,
      'file': MultipartFile.fromBytes(fileData),
    });

    final dio = DioUtil.getDio()!;
    final res = await dio.post(
      'https://$bucketName.$endpoint',
      options: Options(
        responseType: ResponseType.plain,
      ),
      data: formData,
    );

    return OSSResponse(res.statusCode, res.statusMessage, fileKey);
  }

  Future<OSSResponse> postObjectWithFile(
    File file,
    String bucketName,
    String fileKey, {
    ObjectACL acl = ObjectACL.inherited,
  }) async {
    final OSSFederationToken token = await credentialProvider.getToken();

    FormData formData = FormData.fromMap({
      //文件名，随意
      'Filename': fileKey,
      //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'key': fileKey, //上传后的文件名
      'policy': SignUtil.getBase64Policy(),
      //Bucket 拥有者的AccessKeyId。
      //  accessKeyId 大小写 和服务端返回的对应就成，不要在意这些细节  下同
      'OSSAccessKeyId': token.accessKey,
      //让服务端返回200，不然，默认会返回204
      'success_action_status': '200',
      'signature': SignUtil.getSignature(token.secretKey),
      //临时用户授权时必须，需要携带后台返回的security-token
      'x-oss-security-token': token.token,
      // 指定OSS创建Object时的访问权限
      'x-oss-object-acl': acl.parameter,
      'file': await MultipartFile.fromFile(file.path),
    });

    final dio = DioUtil.getDio()!;

    final uri = Uri.tryParse(endpointUrl)!;
    final host = '$bucketName.${uri.host}';
    final fullUri = uri.replace(host: host);

    final res = await dio.post(
      fullUri.toString(),
      options: Options(
        responseType: ResponseType.plain,
      ),
      data: formData,
    );

    return OSSResponse(res.statusCode, res.statusMessage, fileKey);
  }

  /// RESTFul API: HeadObject
  Future<Object> headObject() async {
    throw UnimplementedError();
  }

  /// RESTFul API: GetObject
  Future<Object> getObject() async {
    throw UnimplementedError();
  }

  /// RESTFul API: GetObjectACL
  Future<Object> getObjectACL() async {
    throw UnimplementedError();
  }

  /// RESTFul API: PutObject
  Future<Object> putObjectWithFile(
    File file, {
    required String bucketName,
    required String objectKey,
    ObjectACL acl = ObjectACL.inherited,
  }) async {
    final request = OSSRequest(
      endpoint: endpoint,
      bucketName: bucketName,
      objectKey: objectKey,
      acl: acl,
      httpMethod: 'PUT',
      file: file,
    );
    await _signer.sign(request);
    _dio.put(
      request.url,
      data: MultipartFile.fromFileSync(file.path).finalize(),
      options: Options(
        headers: request.headers,
      ),
    );
    return '';
  }

  /// RESTFul API: PostObject
  Future<Object> postObject() async {
    throw UnimplementedError();
  }

  /// RESTFul API: DeleteObject
  Future<Object> deleteObject() async {
    throw UnimplementedError();
  }
}
