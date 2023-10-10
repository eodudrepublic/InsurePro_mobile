import 'package:flutter/material.dart';
import 'package:insurepro_mobile/_core/app_color.dart';
import 'planner/planner_main_ui.dart';
import 'customer_db/customer_db_ui.dart';
import 'my_page/mypage_ui.dart';

class MainPages extends StatefulWidget {
  const MainPages({Key? key}) : super(key: key);

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int _currentIndex = 1;

  final List<Widget> _children = [
    ShowCustomerDB(),
    TeamPlanner(),
    MyPageUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: main_color,  // BottomNavigationBar의 배경색 설정
        currentIndex: _currentIndex,
        selectedItemColor: selected_bottom_menu,  // 선택된 아이콘의 색상 설정
        unselectedItemColor: unselected_bottom_menu,  // 선택되지 않은 아이콘의 색상 설정
        showSelectedLabels: false,  // label 가리기
        showUnselectedLabels: false,  // label 가리기
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: '고객 DB',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '팀 플래너',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '마이 페이지',
          ),
        ],
      ),
    );
  }
}
