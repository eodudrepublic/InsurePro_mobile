import 'package:flutter/material.dart';
import '../signin/login_ui.dart';

class ShowIDUI extends StatefulWidget {
  final String name;
  final String id;

  const ShowIDUI({super.key, required this.name, required this.id});

  @override
  State<ShowIDUI> createState() => _ShowIDUIState();
}

class _ShowIDUIState extends State<ShowIDUI> {
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
              const SizedBox(height: 30),

              // show name & email
              Text(
                '${widget.name} 님의 아이디는',
                style: const TextStyle(
                    fontFamily: 'Product Sans',
                    letterSpacing: 0.15,
                    fontSize: 20
                ),
              ),
              Text(
                widget.id,
                style: const TextStyle(
                  color: Color(0xFF175CD3),
                  fontSize: 20,
                  fontFamily: 'Product Sans',
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.15,
                ),
              ),
              const Text(
                '입니다.',
                style: TextStyle(
                    fontFamily: 'Product Sans',
                    letterSpacing: 0.15,
                    fontSize: 20
                ),
              ),

              // to LogIn
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInUI()),  // LogInUI는 로그인 화면의 위젯입니다.
                  );
                },
                child: const Text('로그인 하러 가기'),
              ),
            ],
          ),
        ),
      );
  }
}