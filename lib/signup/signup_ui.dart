import 'package:flutter/material.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/signin/login_ui.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/signup/select_team.dart';
import 'dart:convert';
import '../_core/logo.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({Key? key}) : super(key: key);

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idNumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController authCodeController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController repwController = TextEditingController();
  String emailResponseMessage = '';
  String codeResponseMessage = '';
  bool _obscureText = true;
  bool isNextButtonEnabled = false; // '다음' 버튼 활성화 여부를 위한 변수

  @override
  void initState() {
    super.initState();
    nameController.addListener(validateForm);
    idNumController.addListener(validateForm);
    pwController.addListener(validateForm);
    repwController.addListener(validateForm);
  }

  // 인증 메일 보내는 함수
  Future<void> sendAuthEmail() async {
    var url = Uri.parse(URL.email_url);
    var response = await http.post(
      url,
      body: json.encode({
        'email': emailController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    setState(() {
      emailResponseMessage = response.body;
      print(response.body);
    });
  }

  // 인증 코드 체크하는 함수
  Future<void> checkAuthCode() async {
    var url = Uri.parse(URL.emailcheck_url);

    var request = http.Request('GET', url)
      ..headers['Content-Type'] = 'application/json'
      ..body = json.encode({
        "email": emailController.text,
        "authNum": authCodeController.text,
      });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    setState(() {
      codeResponseMessage = response.body;
      print(response.body);
    });
  }

  // 폼의 유효성 검사
  void validateForm() {
    setState(() {
      isNextButtonEnabled = nameController.text.isNotEmpty &&
          idNumController.text.isNotEmpty &&
          pwController.text.isNotEmpty &&
          repwController.text.isNotEmpty &&
          pwController.text == repwController.text &&
          codeResponseMessage.contains(authCodeController.text); // 응답에서 authNum이 맞는지 확인
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo
              const InsureProLogo(),
              const SizedBox(height: 20),

              // to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('이미 회원이신가요?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LogInUI()),  // LogInUI는 로그인 화면의 위젯입니다.
                      );
                    },
                    child: const Text('여기서 로그인하기!'),
                  ),
                ],
              ),

              // 이름 입력
              TextField(
                controller: nameController,
                onChanged: (_) => validateForm(),
                decoration: const InputDecoration(
                  labelText: '이름 입력하기',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 사번 입력
              TextField(
                controller: idNumController,
                onChanged: (_) => validateForm(),
                decoration: const InputDecoration(
                  labelText: '사번 입력하기',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 이메일 입력 -> 인증
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: '이메일 입력하기',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: sendAuthEmail, // 1. 인증 이메일 보내는 코드
                    child: const Text('코드 전송'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 인증 코드 입력
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: authCodeController,
                      decoration: const InputDecoration(
                        labelText: '인증 코드 입력하기',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: checkAuthCode, // 2. 코드 인증 기능
                    child: const Text('확인'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              TextField(
                controller: pwController,
                onChanged: (_) => validateForm(),
                decoration: InputDecoration(
                  labelText: '비밀번호 입력하기',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 16),

              // 비밀번호 확인
              TextField(
                controller: repwController,
                onChanged: (_) => validateForm(), // 비밀번호 확인 값이 변경되면 폼 유효성 검사
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  errorText: pwController.text != repwController.text
                      ? '비밀번호가 다릅니다!'
                      : null, // 조건에 따라 에러 텍스트 표시
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 16),

              // 다음 페이지 (팀 선택 화면으로 넘어가는 버튼)
              ElevatedButton(
                onPressed: isNextButtonEnabled // 버튼 활성화 여부 체크
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectTeamPage(
                        name: nameController.text,
                        idNumber: idNumController.text,
                        email: emailController.text,
                        authCode: authCodeController.text,
                        password: pwController.text,
                        repassword: repwController.text,
                      ),
                    ),
                  );
                }
                    : null,
                child: const Text('다음'),
              ),

              // 인증을 위한 임시 출력 -> 배포할때 없앨것
              const SizedBox(height: 30),
              Text(emailResponseMessage),
              const SizedBox(height: 5),
              Text(codeResponseMessage),
            ],
          ),
        ),
      ),
    );
  }
}
