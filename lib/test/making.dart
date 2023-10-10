import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:insurepro_mobile/_core/app_color.dart';

class TestMaking extends StatefulWidget {
  const TestMaking({super.key});

  @override
  _TestMakingState createState() => _TestMakingState();
}

class _TestMakingState extends State<TestMaking> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://3.38.101.62:8080/v1/photos'),
    );

    // JSON 형식의 필드를 추가
    request.fields['request'] = json.encode({'employeePk': 10});

    // 이미지 파일 추가
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    print(request);

    var response = await request.send();

    if (response.statusCode == 201) {
      print('Image uploaded!');
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover),
            ElevatedButton(
              child: Text("사진 추가"),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return SafeArea(
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('갤러리에서 선택'),
                            onTap: () {
                              _getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_camera),
                            title: Text('사진 촬영'),
                            onTap: () {
                              _getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

