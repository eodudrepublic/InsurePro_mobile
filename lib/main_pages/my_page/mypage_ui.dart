import 'package:flutter/material.dart';
import 'package:insurepro_mobile/_core/app_color.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:provider/provider.dart';
import '../../_core/user.dart';

class MyPageUI extends StatelessWidget {
  const MyPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    // User 객체를 불러옵니다.
    User user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: myPage_background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: app_width * 0.90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/default_profile.jpg', height: 50, width: 50),
                  Text('Hello, ${user.email}'),  // 예시로 email을 화면에 표시
                  // 여기에 필요한 다른 위젯들을 추가합니다.
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              color: Colors.white,
              width: app_width * 0.90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Dummy Text'),  // 예시로 email을 화면에 표시
                  // 여기에 필요한 다른 위젯들을 추가합니다.
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}