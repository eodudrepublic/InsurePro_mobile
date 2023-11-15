import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../test/test.dart';

class CustomerDetail extends StatefulWidget {
  final int customerPk;
  const CustomerDetail({super.key, required this.customerPk});

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  late int _customerPk;

  Future<Map<String, dynamic>> fetchCustomerData() async {
    final response = await http.get(
      Uri.parse('http://3.38.101.62:8080/v1/customer/$_customerPk'),
      headers: {'Authorization': TestToken.testToken},
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch customer data');
    }
  }

  @override
  void initState() {
    super.initState();
    _customerPk = widget.customerPk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCustomerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('고객 유형: ${data['customerType']}'),
                  Text('이름: ${data['name']}'),
                  Text('생년월일: ${data['birth']}'),
                  Text('만 나이: ${data['age']}'),
                  Text('주소: ${data['dongString']} ${data['address']}'),
                  Text('전화번호: ${data['phone']}'),
                  Text('특이사항: ${data['memo']}'),
                  Text('상태: ${data['state']}'),
                  Text('계약 여부: ${data['contractYn'] ? '예' : '아니오'}'),
                  Text('삭제 여부: ${data['delYn'] ? '예' : '아니오'}'),
                  Text('등록 날짜: ${data['registerDate']}'),
                  Text('생성된 날짜: ${data['createdAt']}'),
                  Text('수정된 날짜: ${data['modifiedAt']}'),
                ],
              ),
            );
          }
          return Center(child: Text('데이터가 없습니다.'));
        },
      ),
    );
  }
}

