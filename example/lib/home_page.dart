// ignore_for_file: avoid_print

import 'dart:io';

import 'package:aliyun_oss_example/component/list_card.dart';
import 'package:aliyun_oss_example/oss_manager.dart';
import 'package:flutter/material.dart';
import 'package:aliyun_oss/aliyun_oss.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final OSSFederationCredentialProvider _provider =
      OSSAuthCredentialProvider(stsTokenUrl: _stsTokenUrl);
  late OSSClient _client;

  final String _stsTokenUrl = 'http://192.168.0.130:10100/sts/getsts';
  final String _bucketName = 'example-bucket-shanghai';
  final String _endpoint = 'http://oss-cn-shanghai.aliyuncs.com';

  @override
  void initState() {
    _client = OSSClient(
      endpoint: _endpoint,
      credentialProvider: _provider,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aliyun oss'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListCard(
              title: 'getStsToken',
              onTap: () {
                _getStsToken();
              },
            ),
            ListCard(
              title: 'OSSManager - getStsToken',
              onTap: () {
                _managerGetStsToken();
              },
            ),
            ListCard(
              title: 'headObject',
              onTap: () {
                _headObject(context);
              },
            ),
            ListCard(
              title: 'putObject',
              onTap: () {
                _putObject(context);
              },
            ),
            ListCard(
              title: 'postObject',
              onTap: () {
                _postObject(context);
              },
            ),
            ListCard(
              title: 'getObject',
              onTap: () {
                _getObject(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getStsToken() async {
    try {
      final token = await _provider.getToken();
      print('===get stsToken success==$token');
    } catch (e) {
      // error
      print('===getStsToken error==$e');
    }
  }

  Future<void> _managerGetStsToken() async {
    try {
      final token =
          await OSSManager().defaultClient.credentialProvider.getToken();
      print('===get stsToken success==$token');
    } catch (e) {
      // error
      print('===getStsToken error==$e');
    }
  }

  Future<void> _headObject(BuildContext context) async {
    try {
      const objectKey = 'example_1655451016408.jpg';
      _client.headObject(bucketName: _bucketName, objectKey: objectKey);
    } catch (e) {
      // error
    }
  }

  Future<void> _putObject(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final file = await picker.pickImage(source: ImageSource.gallery);
      final imagePath = file?.path;
      if (imagePath?.isEmpty ?? true) {
        return;
      }
      print('=====pick image==path:$imagePath');
      final date = DateTime.now();
      final objectKey = 'example_${date.millisecondsSinceEpoch}.jpg';
      _client.putObjectWithFile(File(imagePath!),
          bucketName: _bucketName, objectKey: objectKey);
    } catch (e) {
      // error
    }
  }

  Future<void> _postObject(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final file = await picker.pickImage(source: ImageSource.gallery);
      final imagePath = file?.path;
      if (imagePath?.isEmpty ?? true) {
        return;
      }
      print('=====pick image==path:$imagePath');
      final date = DateTime.now();
      final objectKey = 'example_${date.millisecondsSinceEpoch}.jpg';
      final res = await _client.postObjectWithFile(
          File(imagePath!), _bucketName, objectKey);
      print('====postObject==$res');
    } catch (e) {
      // error
    }
  }

  Future<void> _getObject(BuildContext context) async {
    try {
      const objectKey = 'example_1655451016408.jpg';
      _client.getObject(bucketName: _bucketName, objectKey: objectKey);
    } catch (e) {
      // error
    }
  }
}
