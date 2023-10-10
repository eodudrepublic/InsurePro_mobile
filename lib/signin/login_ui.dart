import 'package:flutter/material.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/find_id/find_id_ui.dart';
import 'package:insurepro_mobile/reset_pw/reset_pw_ui.dart';
import 'package:insurepro_mobile/signup/signup_ui.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../_core/app_color.dart';
import '../_core/logo.dart';
import '../_core/text_field.dart';
import '../_core/user.dart';
import 'login_success.dart';

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
    pwController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
  }

  Future<void> _loadSavedData() async {
    Map<String, dynamic> accountData = await _localAccountManager.selectData();
    if (accountData['email']!.isNotEmpty && accountData['password']!.isNotEmpty) {
      emailController.text = accountData['email'];
      pwController.text = accountData['password'];
    }
  }

  Future<void> _login() async {
    var url = Uri.parse(URL.signin_url);
    // print(emailController.text);
    // print(pwController.text);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',  // 추가한 헤더
      },
      body: jsonEncode({  // Map을 JSON 문자열로 변환
        "email": emailController.text,
        "password": pwController.text,
      }),
    );

    if (response.statusCode == 200) {
      if (checkBoxValue) {
        // 체크박스가 선택되면, 계정 정보를 업데이트합니다.
        await _localAccountManager.updateData(emailController.text, pwController.text);
      }
      var data = jsonDecode(response.body);

      // 여기서 저장되는 user 정보를 앱 동작동안 사용 가능하도록 수정해야함
      // User 객체를 현재 컨텍스트에서 불러옵니다.
      User user = Provider.of<User>(context, listen: false);

      // 로그인한 사용자 정보 저장
      user.setToken(response.headers['authorization']);
      // print(response.headers['authorization']);
      user.setRefreshToken(response.headers['refresh']);
      user.setPK(data['pk']);
      user.setID(data['id']);
      user.setEmail(data['email']);
      user.fetchUserInfo();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LogInSuccess(user: user),
        ),
      );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        // 로그인 오류 메세지 좀 더 보기 좋게 ㄱㄱ
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: app_width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬을 위한 속성
            children: [
              // logo
              const InsureProLogo(),
              const SizedBox(height: 20),

              // email 입력
              CustomTextField(
                controller: emailController,
                iconData: Icons.email_outlined,
                hintText: '이메일 입력하기',
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),

              // password 입력
              CustomPwField(
                controller: pwController,
                iconData: Icons.lock_outlined,
                hintText: 'Password',
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),

              // 계정 저장 체크
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const Text('다음에도 기억하기'),
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
                        builder: (context) => const ResetPWUI()),
                  );
                },
                child: const Text('아이디 찾기'),
              ),

              // 이메일 찾기
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FindIDUI()),  // ID(email) 찾기 페이지로 이동 (뒤로 가기 가능)
                  );
                },
                child: const Text('비밀번호 찾기'),
              ),

              // Sign in button
              ElevatedButton(
                onPressed: (emailController.text.isNotEmpty && pwController.text.isNotEmpty)
                    ? _login : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return disabled_gray;
                      }
                      return main_color;
                    }
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),  // 둥근 모서리 지정
                      )
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
