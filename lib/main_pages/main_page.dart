import 'package:flutter/material.dart';
import 'main_navigation_bar.dart';
import 'planner/team_planner.dart';
import 'customer_db/customer_db_ui.dart';
import 'my_page/mypage_ui.dart';

class MainPages extends StatefulWidget {
  final int pageIndex;
  const MainPages({super.key, this.pageIndex = 1});

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  late int _currentIndex;

  final List<Widget> _children = [
    const ShowCustomerDB(),
    const TeamPlanner(),
    const MyPageUI(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: MainBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    );
  }
}
