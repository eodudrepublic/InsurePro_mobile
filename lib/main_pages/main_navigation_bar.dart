import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../_core/app_color.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  MainBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});

  // 피그마에서 추출한 svg로 아이콘 설정
  Widget _buildIcon(String enabledPath, String disabledPath, int index) {
    return SvgPicture.asset(
      currentIndex == index ? enabledPath : disabledPath,
      width: 30,
      height: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: main_color,
      currentIndex: currentIndex,
      selectedItemColor: selected_bottom_menu,
      unselectedItemColor: unselected_bottom_menu,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) => onTap(index),
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/users_abled.svg', 'assets/images/users_disabled.svg', 0),
          label: '고객 DB',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/bx_calendar_abled.svg', 'assets/images/bx_calendar_disabled.svg', 1),
          label: '팀 플래너',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/person_abled.svg', 'assets/images/person_disabled.svg', 2),
          label: '마이 페이지',
        ),
      ],
    );
  }
}
