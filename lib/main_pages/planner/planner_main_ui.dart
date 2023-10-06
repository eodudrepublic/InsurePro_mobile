import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:provider/provider.dart';

import '../../_core/user.dart';

class TeamPlanner extends StatefulWidget {
  const TeamPlanner({super.key});

  @override
  _TeamPlannerState createState() => _TeamPlannerState();
}

class _TeamPlannerState extends State<TeamPlanner> {
  Future<Map<String, dynamic>>? _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    // User user = Provider.of<User>(context);
    // final response = await http.get(Uri.parse(URL.get_team_planner + user.pk.toString()));

    final response = await http.get(Uri.parse('${URL.get_team_planner}10'));
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            var myPlannerPhotoUrl = snapshot.data!['myPlanner']['photo']['photoUrl'];
            var myTeam = snapshot.data!['myTeam'] as List<dynamic>;

            return Column(
              children: [
                Text('My Planner'),
                Expanded(
                  flex: 3, // 이 값을 조정하여 원하는 비율로 공간을 차지하도록 설정할 수 있습니다.
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: myPlannerPhotoUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),

                Text("My Team's"),
                // 이 Expanded 때문에 사진이 정사각형으로 안보임 -> 나중에 사이즈 정해주도록 수정
                Expanded(
                    flex: 1, // 이 값을 조정하여 원하는 비율로 공간을 차지하도록 설정할 수 있습니다.
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: myTeam.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: myTeam[index]['photo']['photoUrl'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,  // 원하는 크기로 변경
                                  height: 100,  // 원하는 크기로 변경
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(myTeam[index]['photo']['photoUrl']),
                                      fit: BoxFit.cover,  // 이미지를 컨테이너에 맞게 조정
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0), // 조금의 간격을 줍니다.
                                Text(myTeam[index]['employee']['name']),  // 직원의 이름을 표시
                              ],
                            ),
                          ),
                        );
                      },
                    )
                ),
              ],
            );
          }
        },
      ),
    );
  }

}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}