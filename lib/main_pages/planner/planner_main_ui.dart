import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:provider/provider.dart';

import '../../_core/app_color.dart';
import '../../_core/logo.dart';
import '../../_core/user.dart';
import 'my_planner_list.dart';

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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          } else {
            var myPlannerPhotoUrl = snapshot.data!['myPlanner']['photo']['photoUrl'];
            var myTeam = snapshot.data!['myTeam'] as List<dynamic>;

            return Center(
              child: SizedBox(
                width: app_width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            // logo
                            const InsureProLogo(),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // 모든 위젯들을 좌측으로 정렬
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyPlanners()),
                                    );
                                  },
                                  child: const Icon(Icons.format_list_bulleted_rounded),
                                ),

                                // 아이콘과 텍스트 사이의 간격
                                const SizedBox(width: 8.0),
                                const Text(
                                  "My Planner",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.left,
                                ),

                                // 텍스트와 오른쪽 아이콘 사이의 늘어나는 간격
                                const Spacer(),
                                Icon(
                                  Icons.add_circle_sharp,
                                  color: main_color,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      imageUrl: myPlannerPhotoUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: myPlannerPhotoUrl,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),

                    const Text(
                      "My Team’s",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff000000),
                        height: 24/24,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 150,
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
                                  const SizedBox(height: 5.0), // 조금의 간격을 줍니다.
                                  Text(myTeam[index]['employee']['name']),  // 직원의 이름을 표시
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
        backgroundColor: Colors.black,
        elevation: 0, // 앱바 그림자 제거
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}