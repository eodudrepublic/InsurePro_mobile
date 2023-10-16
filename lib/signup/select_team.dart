import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'dart:convert';
import '../_core/app_color.dart';
import '../_core/logo.dart';
import '../_core/team.dart';
import '../signin/login_ui.dart';

class SelectTeamPage extends StatefulWidget {
  final String name;
  final String idNumber;
  final String email;
  final String authCode;
  final String password;
  final String repassword;

  const SelectTeamPage({
    Key? key,
    required this.name,
    required this.idNumber,
    required this.email,
    required this.authCode,
    required this.password,
    required this.repassword,
  }) : super(key: key);

  @override
  _SelectTeamPageState createState() => _SelectTeamPageState();
}

class _SelectTeamPageState extends State<SelectTeamPage> {
  List<Team> teams = [];
  Team? selectedTeam;
  bool isButtonEnabled = false;  // '가입하기' 버튼 활성화를 위한 변수
  String? message;  // 표시할 메세지를 저장할 변수

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    var url = Uri.parse(URL.team_url);
    var response = await http.get(url);
    final decodedData = utf8.decode(response.bodyBytes);
    List<dynamic> body = jsonDecode(decodedData)['teams'];

    setState(() {
      teams = body.map((dynamic item) => Team.fromJson(item)).toList();
    });
  }

  // 회원가입 메서드
  Future<void> _signUp() async {
    var url = Uri.parse(URL.signup_url);
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "id": widget.idNumber,
      "name": widget.name,
      "password": widget.password,
      "rePassword": widget.repassword,
      "teamPk": selectedTeam?.pk,  // long이나 int 타입이므로 그대로 두어도 됩니다.
      "authNum": int.parse(widget.authCode)  // String에서 int로 변환합니다.
    };

    var response = await http.post(
      url,
      body: json.encode(requestBody),  // body를 JSON 문자열로 변환
      headers: {"Content-Type": "application/json"},
    );

    setState(() {
      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SuccessPage()));
      } else {
        // 오류코드 테스트 필요
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ErrorPage(errorCode: response.statusCode)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: app_width * 0.67,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬을 위한 속성
            children: [
              // logo
              const InsureProLogo(),
              const SizedBox(height: 24),

              // 이전으로 돌아가기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.black,
                      size: 11,
                    ),
                    label: const Text(
                      '이전으로 돌아가기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),

              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Team Name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: disabled_gray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<Team>(
                      isExpanded: true, // 전체 너비 사용
                      alignment: Alignment.centerRight,
                      hint: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "팀을 선택하세요",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      value: selectedTeam,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.black,
                        size: 24,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.white,
                      items: teams.map((Team team) {
                        return DropdownMenuItem<Team>(
                          value: team,
                          child: Text(
                            team.teamName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Team? newValue) {
                        setState(() {
                          selectedTeam = newValue;
                          if (newValue != null) {
                            isButtonEnabled = true;
                          } else {
                            isButtonEnabled = false;
                          }
                        });
                      },
                    ),
                    // SizedBox(height: 20),
                    // Text("선택한 팀: ${selectedTeam?.teamName ?? "선택되지 않음"}"),
                    // SizedBox(height: 20),
                    // Text("선택한 팀의 pk: ${selectedTeam?.pk ?? "None"}"),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              SizedBox(
                height: 53,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _signUp : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return disabled_gray;
                        }
                        return main_color;
                      }
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),  // 둥근 모서리 지정
                        )
                    ),
                  ),
                  child: const Text('가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 회원가입 성공 페이지
class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('회원가입에 성공하였습니다!'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LogInUI()));
              },
              child: const Text('로그인하러 가기'),
            )
          ],
        ),
      ),
    );
  }
}

// 회원가입 실패 페이지
class ErrorPage extends StatelessWidget {
  final int errorCode;

  const ErrorPage({super.key, required this.errorCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입 오류')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('회원가입에 실패하셨습니다! 오류 코드: $errorCode'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('뒤로 가기'),
            )
          ],
        ),
      ),
    );
  }
}
