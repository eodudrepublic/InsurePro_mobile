import 'package:flutter/material.dart';
import 'package:insurepro_mobile/signin/login_ui.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({Key? key}) : super(key: key);

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const TextField(
              decoration: InputDecoration(
                labelText: '이름 입력하기',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 사번 입력
            const TextField(
              decoration: InputDecoration(
                labelText: '사번 입력하기',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 이메일 입력 -> 인증
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '이메일 입력하기',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 인증 이메일 보내는 코드 작성
                  },
                  child: const Text('코드 전송'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 인증 코드 입력
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '인증 코드 입력하기',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 코드 인증 기능 구현
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 비밀번호 입력
            TextField(
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
            
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Scaffold()),
                );
              },
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
