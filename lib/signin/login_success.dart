import 'package:flutter/material.dart';
import '../_core/logo.dart';
import '../_core/user.dart';

class LogInSuccess extends StatefulWidget {
  final User user;

  const LogInSuccess({required this.user, Key? key}) : super(key: key);

  @override
  State<LogInSuccess> createState() => _LogInSuccessState();
}

class _LogInSuccessState extends State<LogInSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            const InsureProLogo(),
            const SizedBox(height: 20),

            // 성공은 했지만 로그인 화면에서 바로 넘어올때 null값이 출력하는 경우 있음 -> 대기 시간을 만들거나 해야할듯
            Text('${widget.user.name}님 환영합니다!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Main/MainPage');
              },
              child: Text('플래너 확인하러 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
