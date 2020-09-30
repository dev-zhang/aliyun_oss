import 'dart:io';

import 'package:aliyun_oss/aliyun_oss.dart';
import 'package:aliyun_oss/src/object_acl.dart';
import 'package:aliyun_oss/src/oss_credential.dart';
import 'package:aliyun_oss/src/oss_credential_provider.dart';
import 'package:aliyun_oss/src/oss_response.dart';
import 'package:aliyun_oss/src/sign_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'dio_util.dart';

class OSSClient {
  OSSClient({
    @required this.endpoint,
    @required this.credentialProvider,
  })  : assert(endpoint?.isNotEmpty ?? false),
        assert(credentialProvider != null);

  final String endpoint;
  final OSSAuthCredentialProvider credentialProvider;

  Future<OSSResponse> postObject(
    List<int> fileData,
    String bucketName,
    String fileKey,
  ) async {
    final OSSCredential credential = await credentialProvider.getCredential();

    FormData formData = FormData.fromMap({
      //文件名，随意
      'Filename': fileKey,
      //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'key': fileKey, //上传后的文件名
      'policy': SignUtil.getBase64Policy(),
      //Bucket 拥有者的AccessKeyId。
      //  accessKeyId 大小写 和服务端返回的对应就成，不要在意这些细节  下同
      'OSSAccessKeyId': credential.accessKeyId,
      //让服务端返回200，不然，默认会返回204
      'success_action_status': '200',
      'signature': SignUtil.getSignature(credential.accessKeySecret),
      //临时用户授权时必须，需要携带后台返回的security-token
      'x-oss-security-token': credential.securityToken,
      'file': MultipartFile.fromBytes(fileData),
    });

    final dio = DioUtil.getDio();
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
    assert(acl != null, "ACL不能为空");
    final OSSCredential credential = await credentialProvider.getCredential();

    FormData formData = FormData.fromMap({
      //文件名，随意
      'Filename': fileKey,
      //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'key': fileKey, //上传后的文件名
      'policy': SignUtil.getBase64Policy(),
      //Bucket 拥有者的AccessKeyId。
      //  accessKeyId 大小写 和服务端返回的对应就成，不要在意这些细节  下同
      'OSSAccessKeyId': credential.accessKeyId,
      //让服务端返回200，不然，默认会返回204
      'success_action_status': '200',
      'signature': SignUtil.getSignature(credential.accessKeySecret),
      //临时用户授权时必须，需要携带后台返回的security-token
      'x-oss-security-token': credential.securityToken,
      // 指定OSS创建Object时的访问权限
      'x-oss-object-acl': acl.parameter,
      'file': await MultipartFile.fromFile(file.path),
    });

    final dio = DioUtil.getDio();
    final res = await dio.post(
      'https://$bucketName.$endpoint',
      options: Options(
        responseType: ResponseType.plain,
      ),
      data: formData,
    );

    return OSSResponse(res.statusCode, res.statusMessage, fileKey);
  }
}
