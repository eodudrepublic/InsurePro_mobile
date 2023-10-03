import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/_core/url.dart';
import 'dart:convert';

import '../_core/team.dart';

class TeamSelector extends StatefulWidget {
  @override
  _TeamSelectorState createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  List<Team> teams = [];
  Team? selectedTeam;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    var url = Uri.parse(URL.team_url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // UTF-8로 응답 바디를 디코드
      final decodedData = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(decodedData)['teams'];

      setState(() {
        teams = body.map((dynamic item) => Team.fromJson(item)).toList();
        print(body); // 디코드된 데이터를 출력하여 확인
      });
    } else {
      throw Exception('Failed to load teams');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<Team>(
              hint: Text("Select a team"),
              value: selectedTeam,
              items: teams.map((Team team) {
                return DropdownMenuItem<Team>(
                  value: team,
                  child: Text(team.teamName),
                );
              }).toList(),
              onChanged: (Team? newValue) {
                setState(() {
                  selectedTeam = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Selected Team: ${selectedTeam?.teamName ?? "None"}"),
          ],
        ),
      ),
    );
  }
}