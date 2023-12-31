import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:insurepro_mobile/_core/app_color.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/logo.dart';
import 'package:insurepro_mobile/test/test.dart';
import 'package:provider/provider.dart';
import '../_core/user.dart';
import 'package:http_parser/http_parser.dart';

class TestMaking extends StatefulWidget {
  const TestMaking({super.key});

  @override
  _TestMakingState createState() => _TestMakingState();
}

class _TestMakingState extends State<TestMaking> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  // base64 문자열을 저장할 상태 변수 추가
  String? _base64Image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);

        // 이미지를 base64로 변환하는 코드 추가
        final bytes = _image!.readAsBytesSync();
        _base64Image = base64Encode(bytes);
      });
      print(_base64Image);
    }
  }

  // 이미지를 서버로 전송하는 함수
  Future<void> _uploadImageToServer() async {
    const url = 'http://3.38.101.62:8080/v1/photos/binary';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'employeePk': 10,
        'photoBinary': _base64Image,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 전송한 경우, 처리 코드 추가 (예: 알림 띄우기)
      print("Image uploaded successfully.");
    } else {
      // 전송에 실패한 경우, 처리 코드 추가 (예: 에러 메시지 띄우기)
      print("Failed to upload image: ${response.body}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),

                if (_image != null) Image.file(_image!, fit: BoxFit.cover),

                SizedBox(height: 10),
                Text('----------------------------------------'),
                SizedBox(height: 10),
                // base64 문자열을 이미지로 변환하여 표시하는 위젯
                if (_base64Image != null)
                  Image.memory(
                      base64Decode(_base64Image!),
                      fit: BoxFit.cover
                  ),
                ElevatedButton(
                  child: Text("사진 추가"),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('갤러리에서 선택'),
                                onTap: () async {
                                  await _getImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                  if (_base64Image != null) {
                                    await _uploadImageToServer();  // 사진 선택 후, 서버로 전송하는 함수 호출
                                  }
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('사진 촬영'),
                                onTap: () async {
                                  await _getImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                  if (_base64Image != null) {
                                    await _uploadImageToServer();  // 사진 선택 후, 서버로 전송하는 함수 호출
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                // base64 문자열 출력 위젯 추가
                if (_base64Image != null)
                  Text(
                    _base64Image!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,  // base64 문자열이 길어질 수 있으므로 최대 5줄로 제한
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}