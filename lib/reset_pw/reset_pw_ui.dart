import 'package:flutter/material.dart';

class ResetPWUI extends StatefulWidget {
  const ResetPWUI({super.key});

  @override
  State<ResetPWUI> createState() => _ResetPWUIState();
}

class _ResetPWUIState extends State<ResetPWUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('비밀번호 재설정 화면'),
    );
  }
}
