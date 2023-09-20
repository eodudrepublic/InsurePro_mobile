import 'package:flutter/material.dart';

class LogInUI extends StatefulWidget {
  const LogInUI({super.key});

  @override
  _LogInUIState createState() => _LogInUIState();
}

class _LogInUIState extends State<LogInUI> {
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // logo
        const Center(
          child: Text(
            'InsurePro',
            style: TextStyle(
              color: Color(0xFF175CD3),
              fontSize: 28,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.18,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // email 입력
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // password 입력
        const TextField(
          decoration: InputDecoration(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Scaffold()),
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
              MaterialPageRoute(
                  builder: (context) => const Scaffold()), // Navigate to blank page
            );
          },
          child: const Text('Forgot Username?'),
        ),

        // Sign in button
        ElevatedButton(
          onPressed: () {
            // 로그인 기능 구현
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
