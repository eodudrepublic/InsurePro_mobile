import 'package:flutter/material.dart';
import 'package:insurepro_mobile/find_id/find_id_ui.dart';
import 'package:insurepro_mobile/signup/signup_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../_core/logo.dart';
import '../_core/user.dart';

class LogInUI extends StatefulWidget {
  const LogInUI({Key? key}) : super(key: key);

  @override
  _LogInUIState createState() => _LogInUIState();
}

class _LogInUIState extends State<LogInUI> {
  bool checkBoxValue = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final LocalAccountManager _localAccountManager = LocalAccountManager();

  @override
  void initState() {
    super.initState();
    _loadSavedData();  // 데이터를 로드합니다.
  }

  Future<void> _loadSavedData() async {
    Map<String, dynamic> accountData = await _localAccountManager.selectData();
    if (accountData['email']!.isNotEmpty && accountData['password']!.isNotEmpty) {
      emailController.text = accountData['email'];
      pwController.text = accountData['password'];
    }
  }

  Future<void> _login() async {
    var url = Uri.parse("http://3.38.101.62:8080/v1/login");
    var response = await http.post(
      url,
      body: {
        "email": emailController.text,
        "password": pwController.text,
      },
    );

    if (response.statusCode == 200) {
      if (checkBoxValue) {
        // 체크박스가 선택되면, 계정 정보를 업데이트합니다.
        await _localAccountManager.updateData(emailController.text, pwController.text);
      }
      var data = jsonDecode(response.body);
      // 여기서 저장되는 user 정보를 앱 동작동안 사용 가능하도록 수정해야함
      User user = User(
        token: response.headers['Authorization'],
        refreshToken: response.headers['Refresh'],
        pk: data['pk'],
        id: data['id'],
        email: data['email'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Scaffold()),  // 로그인 후 빈 페이지로 이동
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬을 위한 속성
        children: [
          // logo
          const InsureProLogo(),
          const SizedBox(height: 20),

          // email 입력
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // password 입력
          TextField(
            controller: pwController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),

          // 계정 저장 체크
          Row(
            children: [
              Checkbox(
                value: checkBoxValue,
                // 내부 저장소? 이용해서 계정 저장하도록 구현
                onChanged: (bool? value) {
                  setState(() {
                    checkBoxValue = value!;
                  });
                },
              ),
              const Text('Remember Me'),
            ],
          ),

          // to Sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('아직 계정이 없으신가요?'),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpUI()),  // SignUpUI는 회원가입 화면의 위젯입니다.
                  );
                },
                child: const Text('회원가입 하러가기'),
              ),
            ],
          ),

          // 비밀번호 찾기
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold()), // Navigate to blank page
              );
            },
            child: const Text('Forgot Password?'),
          ),

          // 이메일 찾기
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindIDUI()),  // ID(email) 찾기 페이지로 이동 (뒤로 가기 가능)
              );
            },
            child: const Text('Forgot Username?'),
          ),

          // Sign in button
          ElevatedButton(
            onPressed: _login,
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
