import 'package:flutter/material.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/text_field.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/signin/login_ui.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/signup/select_team.dart';
import 'dart:convert';
import '../_core/app_color.dart';
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
  FocusNode emailFocusNode = FocusNode();
  String codeResponseMessage = '';
  FocusNode codeFocusNode = FocusNode();
  bool isNextButtonEnabled = false; // '다음' 버튼 활성화 여부를 위한 변수

  @override
  void initState() {
    super.initState();
    nameController.addListener(validateForm);
    idNumController.addListener(validateForm);
    pwController.addListener(validateForm);
    repwController.addListener(validateForm);
    emailController.addListener(() => setState(() {})); // 리스너 추가
    emailFocusNode.addListener(() => setState(() {}));
    authCodeController.addListener(() => setState(() {}));
    codeFocusNode.addListener(() => setState(() {}));
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
  void dispose() {
    emailFocusNode.dispose();
    codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: app_width * 0.67,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  const SizedBox(height: 20),
                  const InsureProLogo(),
                  const SizedBox(height: 24),

                  // to Login -> 줄 간격 맞춰야함
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '이미 회원이신가요?',
                          style: TextStyle(
                            fontSize: 12,
                            height: 0.1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LogInUI()),  // LogInUI는 로그인 화면의 위젯입니다.
                            );
                          },
                          child: const Text(
                            '여기서 로그인하기!',
                            style: TextStyle(
                              fontSize: 12,
                              height: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이름 입력
                        SizedBox(height: 11),
                        CustomTextField(
                          controller: nameController,
                          iconData: Icons.person_rounded,
                          hintText: 'User Name',
                          onChanged: (_) => validateForm(),
                        ),
                        const SizedBox(height: 40),

                        // 사번 입력
                        CustomTextField(
                          controller: idNumController,
                          iconData: Icons.person_rounded,
                          hintText: 'User Number',
                          onChanged: (_) => validateForm(),
                        ),
                        const SizedBox(height: 40),

                        // 이메일 입력 -> 인증
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: emailController,
                                iconData: Icons.email_outlined,
                                hintText: 'example@gmail.com',
                                onChanged: (_) {},
                                focusNode: emailFocusNode,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: emailFocusNode.hasFocus // 포커스 상태에 따라 색상을 변경합니다.
                                        ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: emailController.text.contains('@') && emailController.text.contains('.')
                                    ? sendAuthEmail : null,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          return (emailController.text.contains('@') && emailController.text.contains('.'))
                                              ? main_color : disabled_gray;
                                        }
                                    )
                                ),
                                child: const Text('코드 전송'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // 인증 코드 입력
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: authCodeController,
                                iconData: Icons.email_outlined,
                                hintText: '인증 코드를 입력해주세요',
                                onChanged: (_) {},
                                focusNode: codeFocusNode,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: codeFocusNode.hasFocus // 포커스 상태에 따라 색상을 변경합니다.
                                        ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: authCodeController.text.isNotEmpty ? checkAuthCode : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      return authCodeController.text.isNotEmpty
                                          ? main_color : disabled_gray;
                                    },
                                  ),
                                ),
                                child: const Text('확인'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // 비밀번호 입력
                        CustomPwField(
                          controller: pwController,
                          iconData: Icons.lock_outlined,
                          hintText: 'Password',
                          onChanged: (_) => validateForm(),
                          isError: pwController.text.length <= 8,
                          errorMessage: '* 비밀번호는 8자 이상으로 설정해주세요.',
                        ),
                        const SizedBox(height: 40),

                        // 비밀번호 확인
                        CustomPwField(
                          controller: repwController,
                          iconData: Icons.lock_outlined,
                          hintText: 'Verify Password',
                          onChanged: (_) => validateForm(),
                          isError: pwController.text != repwController.text,
                          errorMessage: '비밀번호가 다릅니다!',
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),

                // 다음 페이지 (팀 선택 화면으로 넘어가는 버튼)
                SizedBox(
                  height: 53,
                  child: ElevatedButton(
                    onPressed: isNextButtonEnabled ? () {
                      Navigator.push(context,
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
                    } : null,
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
                        )
                    ),
                    child: const Text('다음'),
                  ),
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
        ),
      ),
    );
  }
}

