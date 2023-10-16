import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../_core/app_size.dart';

// 테스트용 토큰 저장
class TestToken {
  static const testToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJVU0VSIiwiVVNFUiJdLCJpZCI6IjIwMjA1NTUxMyIsInN1YiI6InRlc3RAZ21haWwuY29tIiwiaWF0IjoxNjk3MTc5MDAzLCJleHAiOjE2OTc3NzkwMDN9.sIAMRqZheAVXh06ixfRBL2T8m6jrtz-dYj7sbuqz5wg';
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Developing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 회원가입 & 로그인
            _category(title: '회원가입 & 로그인', widgets: [
              _item(
                context: context,
                content: '로그인',
                namedRouter: '/Sign/LogIn',
                isPost: true,
              ),
              _item(
                context: context,
                content: '로그인 성공',
                namedRouter: '/Sign/LogInSuccess',
                isPost: true,
              ),
              _item(
                context: context,
                content: '회원가입',
                namedRouter: '/Sign/SignUp',
                isPost: true,
              ),
              _item(
                context: context,
                content: '팀선택 (test)',
                namedRouter: '/Sign/SelectTeamTest',
                isPost: true,
              ),
              _item(
                context: context,
                content: 'ID 찾기',
                namedRouter: '/Sign/FindID',
                isPost: true,
              ),
              _item(
                context: context,
                content: 'ID 보여주기 (test)',
                namedRouter: '/Sign/ShowID',
                isPost: true,
              ),
              _item(
                context: context,
                content: '비밀번호 리셋',
                namedRouter: '/Sign/ResetPW',
              ),
              _item(
                context: context,
                content: '비밀번호 보여주기 (test)',
                namedRouter: '/Sign/ShowPW',
              ),
            ]),

            // 메인 동작부
            _category(title: "Main Page", widgets: [
              _item(
                length: 1,
                context: context,
                content: '메인 화면',
                namedRouter: '/Main/MainPage',
                isPost: true,
              ),
              _item(
                length: 3,
                context: context,
                content: '고객 DB 화면',
                namedRouter: '/Main/CustomerDBUI',
                isPost: true,
              ),
              _item(
                length: 3,
                context: context,
                content: '팀 플래너 화면',
                namedRouter: '/Main/PlannerUI',
                isPost: true,
              ),
              _item(
                length: 3,
                context: context,
                content: '마이 페이지 화면',
                namedRouter: '/Main/MyPageUI',
                isPost: true,
              ),
              _item(
                length: 3,
                context: context,
                content: '고객 추가 창',
                namedRouter: '/Main/AddCustomerUI',
                isPost: true,
              ),
            ]),

            _category(title: "Making", widgets: [
              _item(
                length: 1,
                context: context,
                content: '만들고 있는중',
                namedRouter: '/Test/Making',
                // isPost: true,
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  IgnorePointer _item({
    required BuildContext context,
    required String content,
    String? namedRouter,
    int length = 2,
    bool isPost = false,
  }) {
    return IgnorePointer(
      ignoring: namedRouter == null,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          if (namedRouter != null) {
            Navigator.of(context).pushNamed(namedRouter);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: length == 1
                ? size.width
                : length == 2
                ? (size.width / 2) - (50 / 2)
                : length == 3
                ? (size.width / 3) - (60 / 3)
                : size.width,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: namedRouter != null
                  ? (isPost
                  ? Colors.green
                  : const Color.fromRGBO(125, 125, 125, 1))
                  : const Color.fromRGBO(61, 61, 61, 1),
            ),
            child: Center(
              child: Text(
                content,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: namedRouter != null
                        ? const Color.fromRGBO(215, 215, 215, 1)
                        : const Color.fromRGBO(155, 155, 155, 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _category({
    required String title,
    required List<Widget> widgets,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [...widgets],
          ),
        ],
      ),
    );
  }
}
