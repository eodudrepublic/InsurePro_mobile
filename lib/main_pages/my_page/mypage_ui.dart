import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/_core/app_color.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/logo.dart';
import 'package:provider/provider.dart';
import '../../_core/user.dart';

class MyPageUI extends StatefulWidget {
  const MyPageUI({super.key});

  @override
  _MyPageUIState createState() => _MyPageUIState();
}

class _MyPageUIState extends State<MyPageUI> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context); // 사용자 객체 불러옴

    return Scaffold(
      backgroundColor: myPage_background,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: app_width * 0.9, // 위젯 전체 너비 조정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 로고
                const SizedBox(
                  height: 100,
                  child: InsureProLogo(),
                ),

                // 회원 기본 정보
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // 색상을 여기서 설정
                      borderRadius: BorderRadius.all(
                        Radius.circular(5), // 모서리 둥글기 반지름 설정
                      ),
                    ),
                    height: 75,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/default_profile.jpg', height: 50, width: 50),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            // 이 부분 더 수정해야함
                            children: [
                              Text(
                                '아이디(${user.email})',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),  // 예시로 email을 화면에 표시
                              Text('사번번호 / 유저 이름'),
                              Text('팀명')
                            ],
                          )
                          // 여기에 필요한 다른 위젯들을 추가합니다.
                        ],
                      ),
                    )
                ),

                // 계정 파트
                const Text('계정'),
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // 색상을 여기서 설정
                      borderRadius: BorderRadius.all(
                        Radius.circular(5), // 모서리 둥글기 반지름 설정
                      ),
                    ),
                    height: 100,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text('비밀번호 변경'),
                          const Spacer(),

                          Divider(
                            thickness: 1,
                            height: 0,
                            color: modal_disabled,
                          ),

                          const Spacer(),
                          Text('이메일 변경'),
                          const Spacer(),
                        ],
                      ),
                    )
                ),

                // 이용 안내 파트
                const Text('이용 안내'),
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // 색상을 여기서 설정
                      borderRadius: BorderRadius.all(
                        Radius.circular(5), // 모서리 둥글기 반지름 설정
                      ),
                    ),
                    height: 100,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text('앱 버전'),
                          const Spacer(),

                          Divider(
                            thickness: 1,
                            height: 0,
                            color: modal_disabled,
                          ),

                          const Spacer(),
                          Text('문의하기'),
                          const Spacer(),
                        ],
                      ),
                    )
                ),

                // 기타 파트
                const Text('기타'),
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // 색상을 여기서 설정
                      borderRadius: BorderRadius.all(
                        Radius.circular(5), // 모서리 둥글기 반지름 설정
                      ),
                    ),
                    height: 100,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text('회원 탈퇴'),
                          const Spacer(),

                          Divider(
                            thickness: 1,
                            height: 0,
                            color: modal_disabled,
                          ),

                          const Spacer(),
                          Text('로그 아웃'),
                          const Spacer(),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}