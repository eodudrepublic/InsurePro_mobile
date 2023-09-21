import 'package:flutter/material.dart';
import 'package:insurepro_mobile/find_id/find_id_ui.dart';
import 'package:insurepro_mobile/signin/login_ui.dart';
import 'package:insurepro_mobile/signup/signup_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LogInUI(),
    );
  }
}
