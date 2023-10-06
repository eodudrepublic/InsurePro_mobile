import 'package:flutter/material.dart';
import 'package:insurepro_mobile/find_id/find_id_ui.dart';
import 'package:insurepro_mobile/find_id/show_id_ui.dart';
import 'package:insurepro_mobile/main_pages/customer_db/customer_db_ui.dart';
import 'package:insurepro_mobile/main_pages/main_page.dart';
import 'package:insurepro_mobile/main_pages/my_page/mypage_ui.dart';
import 'package:insurepro_mobile/main_pages/planner/planner_main_ui.dart';
import 'package:insurepro_mobile/reset_pw/reset_pw_ui.dart';
import 'package:insurepro_mobile/reset_pw/show_pw_ui.dart';
import 'package:insurepro_mobile/signin/login_success.dart';
import 'package:insurepro_mobile/signin/login_ui.dart';
import 'package:insurepro_mobile/signup/select_team.dart';
import 'package:insurepro_mobile/signup/signup_ui.dart';
import 'package:insurepro_mobile/test/test.dart';
import 'package:provider/provider.dart';
import '_core/user.dart';
import 'main_pages/customer_db/modal_test.dart';
import 'main_pages/planner/planner_test.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => User(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddCustomerModal(),
      routes: {
        '/Sign/LogIn' : (context) => LogInUI(),
        '/Sign/LogInSuccess' : (context) => LogInSuccess(user: User()),
        '/Sign/SignUp' : (context) => SignUpUI(),
        '/Sign/SelectTeamTest' : (context) => SelectTeamPage(name: 'test', idNumber: 'idNumber', email: 'email', authCode: 'authCode', password: 'password', repassword: 'repassword'),
        '/Sign/FindID' : (context) => FindIDUI(),
        '/Sign/ShowID' : (context) => ShowIDUI(name: 'test', id: 'id'),
        '/Sign/ResetPW' : (context) => ResetPWUI(),
        '/Sign/ShowPW' : (context) => ShowPWUI(),

        '/Main/MainPage' : (context) => MainPages(),
        '/Main/CustomerDBUI' : (context) => ShowCustomerDB(),
        '/Main/PlannerUI' : (context) => TeamPlanner(),
        '/Main/MyPageUI' : (context) => MyPageUI(),
      },
    );
  }
}
