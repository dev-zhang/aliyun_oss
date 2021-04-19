import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aliyun_oss/aliyun_oss.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OSSAuthCredentialProvider _provider = OSSAuthCredentialProvider.init(
    authServerUrl: 'https://xx/getStsToken',
    fetcher: (authServerUrl) async {
      return <String, dynamic>{
        "AccessKeyId": "STS.NTcQ5yT1ZzbJmzTdRVx1X4nvP",
        "AccessKeySecret": "BstrQQYJWzcCsjVpZ3QJ2yPC5w3syAqTzvKF5nMeLy7u",
        "SecurityToken":
            "CAIS4gF1q6Ft5B2yfSjIr5fWGo/Nue57zaChb1zlgFIDdL5026vdsjz2IHFJeXNhBusXvv0/lGlR7foYlqFoV4RyWUHfcZOsAzuvXkXzDbDasumZsJYm6vT8a0XxZjf/2MjNGZabKPrWZvaqbX3diyZ32sGUXD6+XlujQ/br4NwdGbZxZASjaidcD9p7PxZrrNRgVUHcLvGwKBXn8AGyZQhK2lEk0Twls/Xi+KDGtEqC1m+d4/QOuoH8LqKja8RRJ5plW7+3prcnK/ebgXELukgTpPcv1fcYoy2oucqGHkJc+QUJ4CmyGoABY72sCeTDDJvh8HKJTvaZVwUhmSpQ4iZvSQog9HO206eNRLfoaaKCAlEWLvEaqPEajY/yk3sRMLYVtt6qOIo4yLWQuHwJKFphqx9M3Do/r+cJAbOL/prK5732s/1+vjNeOSbxPkOZFy5nEnERq3ibBR8K9MNt34TD1MacaxJq18s=",
        "Expiration": "2020-09-09T16:53:20+08:00"
      };
    },
  );
  OSSClient _client;

  @override
  void initState() {
    _client = OSSClient(
      endpoint: 'oss-cn-shanghai.aliyuncs.com',
      credentialProvider: _provider,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aliyun oss'),
      ),
      body: Center(
        child: TextButton.icon(
          onPressed: () {
            _upload(context);
          },
          icon: Icon(Icons.cloud_upload),
          label: Text('upload'),
        ),
      ),
    );
  }

  Future<void> _upload(BuildContext context) async {
    final dir = await getApplicationDocumentsDirectory();
    print('=====dir: $dir');
    final path = dir.path;
    final filePath = '$path/redmi-note7.jpg';
    File file = File(filePath);

    final bytes = await file.readAsBytes();
    _client.postObject(bytes, 'bucket_name', 'redmi-note7.jpg');
  }
}
