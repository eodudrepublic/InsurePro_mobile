import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/test/test.dart';
import 'dart:convert';
import '../../_core/app_color.dart';
import '../main_navigation_bar.dart';
import '../main_page.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerDateController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  bool contractYn = false;
  String? selectedCustomerType;

  // Customer types list
  final List<String> customerTypes = ["OD", "AD", "CP", "CD", "JD", "H", "X", "Y", "Z"];

  bool isFormValid() {
    return selectedCustomerType != null &&
        nameController.text.isNotEmpty &&
        birthController.text.length == 8 &&
        phoneController.text.length == 11 && phoneController.text.startsWith('010') &&
        addressController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: modal_background,
        appBar: AppBar(
          elevation: 0,  // 경계선 제거
          centerTitle: true,  // title을 중앙에 배치
          backgroundColor: modal_background,
          title: const Text(
            "신규 고객 추가",
            style: TextStyle(
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          // 취소 버튼
          leading: TextButton(
            child: Text(
              '취소',
              style: TextStyle(
                color: main_color,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          // 고객 추가 버튼 (완료 버튼)
          actions: <Widget>[
            TextButton(
              onPressed: isFormValid()
                  ? () async {
                String birth = birthController.text;
                String formattedBirth = '${birth.substring(0, 4)}-${birth.substring(4, 6)}-${birth.substring(6)}';

                DateTime birthDate = DateTime.parse(formattedBirth);
                DateTime currentDate = DateTime.now();
                int age = currentDate.year - birthDate.year;
                if (birthDate.isAfter(currentDate.add(Duration(days: -birthDate.day)))) {
                  age--;
                }

                String formattedPhone = '${phoneController.text.substring(0, 3)}-${phoneController.text.substring(3, 7)}-${phoneController.text.substring(7)}';

                String registerDate = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';

                Map<String, dynamic> body = {
                  "customerTypeName": selectedCustomerType,
                  "name": nameController.text,
                  "birth": formattedBirth,
                  "age": age,
                  "address": addressController.text,
                  "phone": formattedPhone,
                  "memo": memoController.text,
                  "state": stateController.text,
                  "contractYn": contractYn,
                  "registerDate": registerDate
                };

                print('customer data :');
                print('Type : $selectedCustomerType, name : ${nameController.text}, registerDate : $registerDate');
                print('$formattedBirth -> age : $age');
                print('address : ${addressController.text}');
                print('phone : $formattedPhone');
                print('memo : ${memoController.text}');
                print('statue : ${stateController.text}');

                var response = await http.post(
                  Uri.parse(URL.add_costomer),
                  headers: {
                    'Content-Type': 'application/json',
                    "Authorization": TestToken.testToken
                  },
                  body: json.encode(body),
                );

                // 고객 추가 성공, 실패 시 동작 추가 필요
                if (response.statusCode == 201) {
                  // 요청이 성공적으로 완료된 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('고객 추가 성공'))
                  );
                  // Navigator.of(context).pop(); // 현재 화면을 닫습니다.
                } else {
                  // 요청이 실패한 경우
                  print(response.body);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error code: ${response.statusCode} - 고객 추가 실패'))
                  );
                }
              } : null, // 비활성화 상태로 두려면 null을 할당하세요.
              child: Text(
                '완료',
                style: TextStyle(
                  color: isFormValid() ? main_color : Color(0xff98a2b3),
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              // 고객 유형
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row( // 버튼들 테두리 구현에 문제가 있어서 테두리 제외했음
                  children: customerTypes.map((type) {
                    int index = customerTypes.indexOf(type); // 현재 항목의 인덱스를 가져옵니다.
                    return ChoiceChip(
                      label: Text(
                        type,
                        style: TextStyle(
                          color: selectedCustomerType == type ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: selectedCustomerType == type,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selectedCustomerType == type) {
                            selectedCustomerType = null;
                          } else {
                            selectedCustomerType = type;
                          }
                        });
                      },
                      selectedColor: main_color, // 선택된 버튼의 배경색
                      backgroundColor: modal_background, // 기본 배경색
                      shape: const RoundedRectangleBorder(),
                    );
                  }).toList(),
                ),
              ),

              // 이름
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),

              // 고객 계약 체결 여부
              InkWell(
                onTap: () {
                  setState(() {
                    contractYn = !contractYn;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      contractYn ? Icons.check_box : Icons.check_box_outlined,
                      color: contractYn ? main_color : modal_disabled,
                    ),
                    SizedBox(width: 8.0),  // 아이콘과 텍스트 간의 간격을 위해 추가
                    Text(
                      contractYn ? '계약 완료 고객' : '계약 미완료 고객',
                      style: TextStyle(
                        color: contractYn ? main_color : modal_disabled,
                      ),
                    ),
                  ],
                ),
              ),

              // 입력창들 디자인대로 수정 필요

              // 생년월일
              TextField(
                controller: birthController,
                decoration: InputDecoration(labelText: "Birth Date"),
              ),

              // 전화번호
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
              ),

              // 주소
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),

              // 특이 사항
              TextField(
                controller: memoController,
                maxLines: 2,
                decoration: InputDecoration(labelText: "Memo"),
              ),

              // 상태
              TextField(
                controller: stateController,
                maxLines: 2,
                decoration: InputDecoration(labelText: "State"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MainBottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            // MainBottomNavigationBar 항목을 클릭하면 해당 페이지로 이동
            if (index != 0) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPages(pageIndex: index)));
            }
          },
        ),
      ),
    );
  }
}
