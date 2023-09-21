import 'package:flutter/material.dart';
import 'package:insurepro_mobile/find_id/show_id_ui.dart';
import '../signin/login_ui.dart';

class FindIDUI extends StatefulWidget {
  const FindIDUI({Key? key}) : super(key: key);

  @override
  State<FindIDUI> createState() => _FindIDUIState();
}

class _FindIDUIState extends State<FindIDUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              const Text(
                'InsurePro',
                style: TextStyle(
                  color: Color(0xFF175CD3),
                  fontSize: 28,
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.18,
                ),
              ),
              const SizedBox(height: 20),

              // to LogIn
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInUI()),  // LogInUI는 로그인 화면의 위젯입니다.
                  );
                },
                child: const Text('로그인 화면으로 돌아가기'),
              ),
              const SizedBox(height: 20),

              // input ID
              const TextField(
                decoration: InputDecoration(
                  labelText: '사번 번호 입력',
                  border: OutlineInputBorder(),
                ),
              ),

              // 해당 버튼을 누르면 서버와 통신 -> 사번에 해당하는 'name'과 'ID(email)'을 전달받아 ShowIDUI에 전달
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ShowIDUI(name: "test", id: "test@gmail.com")),
                  );
                },
                child: const Text('아이디 찾기'),
              ),
            ],
          ),
        ),
      );
  }
}
