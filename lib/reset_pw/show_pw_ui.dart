import 'package:flutter/material.dart';

class ShowPWUI extends StatefulWidget {
  const ShowPWUI({super.key});

  @override
  State<ShowPWUI> createState() => _ShowPWUIState();
}

class _ShowPWUIState extends State<ShowPWUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('비밀번호 재설정 완료 화면'),
    );
  }
}
