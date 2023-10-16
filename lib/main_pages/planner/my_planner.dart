import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:insurepro_mobile/_core/app_color.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/test/test.dart';

import '../main_navigation_bar.dart';
import '../main_page.dart';

class MyPlanner extends StatefulWidget {
  const MyPlanner({super.key});

  @override
  State<MyPlanner> createState() => _MyPlannerState();
}

class _MyPlannerState extends State<MyPlanner> {
  List<Planner> photos = [];
  int? selectedPhotoForDeletion;
  int totalPages = 0;
  int currentPage = 0;
  // 한 페이지에 보여줄 아이템 갯수
  int itemsPerPage = 10;

  // 내 플래너(이미지)받아오는 함수
  Future<List<Planner>> fetchPhotos() async {
    final response = await http.get(
      Uri.parse('${URL.my_planner}10'), // 나중에 User 객체에서 사용자 pk 받아서 사용하도록 수정
      headers: {
        'Authorization': TestToken.testToken  // 여기도 ㅇㅇ
      },
    );

    if (response.statusCode == 201) {
      final List photosJson = json.decode(response.body);
      List<Planner> fetchedPhotos = photosJson.map((photo) => Planner.fromJson(photo)).toList();
      print(fetchedPhotos.length);
      print((fetchedPhotos.length / itemsPerPage).ceil());
      setState(() {
        totalPages = (fetchedPhotos.length / itemsPerPage).ceil() - 1;
      });
      return fetchedPhotos;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<void> _deletePhoto(int pk) async {
    final response = await http.delete(
      Uri.parse('${URL.delete_planner}$pk'),
      headers: {
        'Authorization': TestToken.testToken,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['message'] == 'delete successful') {
        // 삭제 성공
        setState(() {
          photos.removeWhere((photo) => photo.pk == pk);
        });
      }
    } else {
      // 삭제 실패
      print("Failed to delete photo");
    }
  }

  // 임시로 만든 이미지 삭제 팝업창
  void _showDeleteDialog(int pk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('플래너 삭제'),
          content: Text('선택한 플래너를 정말로 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () async {
                await _deletePhoto(pk);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos().then((fetchedPhotos) {
      setState(() {
        photos = fetchedPhotos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // 뒤로 (Team Planner) 화면으로 돌아가는 버튼
              SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: const Text(
                            'My Planner ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            )
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  )
              ),

              // My Planner을 리스트뷰로 보이는 코드
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (currentPage + 1) * itemsPerPage > photos.length
                      ? photos.length - currentPage * itemsPerPage
                      : itemsPerPage,
                  itemBuilder: (context, index) {
                    final photo = photos[currentPage * itemsPerPage + index];
                    // 이미지 등록 날짜 format
                    final dateParts = photo.createdAt.split('T')[0].split('-');
                    final formattedDate = '${dateParts[0]}.${dateParts[1]}.${dateParts[2]}';
                    // 이미지 보이는 부분
                    return Container(
                      // color: disabled_gray,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: app_width * 0.02),

                          // Planner (이미지)
                          SizedBox(
                            width: 80,  // 원하는 크기로 변경
                            height: 80,  // 원하는 크기로 변경
                            child: CachedNetworkImage(
                              imageUrl: photo.photoUrl,
                              fit: BoxFit.cover,
                              // 이미지가 로딩 중일 때 표시할 위젯
                              placeholder: (context, url) => Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(color: disabled_gray)
                                  )
                              ),
                              // 이미지 로딩에 오류가 발생했을 때 표시할 위젯
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outline_sharp,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(width: app_width * 0.025),

                          // 플래너 업로드 날짜 텍스트
                          Expanded(
                            child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  '$formattedDate에 등록된 사진',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: disabled_gray,
                                      letterSpacing: 0.15
                                  ),
                                )
                            ),
                          ),

                          // 이미지 삭제 메뉴
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: app_width * 0.03),
                            child: IconButton(
                              // 삭제 기능만 있어서 아이콘 둘 중에 뭐로 할지 여쭤봐야함
                              // icon: Icon(Icons.delete_outline_outlined),
                              icon: Icon(Icons.keyboard_control),
                              onPressed: () {
                                _showDeleteDialog(photo.pk);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_double_arrow_left_sharp),
                      onPressed: () {
                        setState(() {
                          currentPage = 0;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp),
                      onPressed: () {
                        if (currentPage > 0) {
                          setState(() {
                            currentPage--;
                          });
                        }
                      },
                    ),
                    Text(currentPage > 0 ? (currentPage).toString() : ''),
                    Text(
                      (currentPage + 1).toString(),
                      style: TextStyle(color: main_color),
                    ),
                    Text(currentPage < totalPages ? (currentPage + 2).toString() : ''),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_sharp),
                      onPressed: () {
                        if (currentPage < totalPages) {
                          setState(() {
                            currentPage++;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_double_arrow_right_sharp),
                      onPressed: () {
                        setState(() {
                          currentPage = totalPages;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // MainBottomNavigationBar 항목을 클릭하면 해당 페이지로 이동
          if (index != 1) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPages(pageIndex: index)));
          }
        },
      ),
    );
  }
}

// 플래너(사진)의 정보를 저장할 클래스
class Planner {
  final int pk;
  final String? name;
  final String photoUrl;
  final String createdAt;
  final String modifiedAt;

  Planner({
    required this.pk,
    this.name,
    required this.photoUrl,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Planner.fromJson(Map<String, dynamic> json) {
    // print(json['pk']);
    // // print(json['name'] ?? 'no name');
    // print(json['createdAt']);
    // print(json['photoUrl'] ?? 'empty photo : should delete');

    return Planner(
      pk: json['pk'],
      name: json['name'] ?? 'no name',
      photoUrl: json['photoUrl'] ?? 'error',
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
    );
  }
}