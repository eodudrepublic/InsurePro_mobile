import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:insurepro_mobile/_core/app_color.dart';
import 'package:insurepro_mobile/_core/app_size.dart';
import 'package:insurepro_mobile/_core/logo.dart';
import 'package:insurepro_mobile/_core/url.dart';
import 'package:insurepro_mobile/test/test.dart';
import 'add_customer.dart';

class ShowCustomerDB extends StatefulWidget {
  const ShowCustomerDB({super.key});

  @override
  _ShowCustomerDBState createState() => _ShowCustomerDBState();
}

class _ShowCustomerDBState extends State<ShowCustomerDB> {
  List<dynamic>? customers;
  int currentPage = 1;
  int itemsPerPage = 15;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    final response = await http.get(
      Uri.parse(URL.get_customer_latest),
      headers: {
        'Authorization': TestToken.testToken,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        String source = utf8.decode(response.bodyBytes);
        customers = json.decode(source);
        print(customers);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (customers!.length / itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.white, // 배경색 동일하게 설정해야함
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 고객 유형 창 추가 위치

                const Spacer(),
                const InsureProLogo(),
                const Spacer(),

                // 고객 추가 모달 창
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCustomer()),
                    );
                  },
                  child: Icon(
                    Icons.add_circle_sharp,
                    color: main_color,
                  ),
                ),
                const SizedBox(width: 8.0)
              ],
            ),
            Expanded(
              child: (customers == null)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: (currentPage * itemsPerPage <= customers!.length)
                    ? itemsPerPage
                    : customers!.length % itemsPerPage,
                itemBuilder: (BuildContext context, int index) {
                  int dataIndex = (currentPage - 1) * itemsPerPage + index;
                  var customer = customers![dataIndex];
                  return CustomerTable(
                    customer: customer,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Full Address'),
                            content: Text(customer['address'] ?? '-'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // 배경색 동일하게 설정해야함
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_double_arrow_left_sharp),
              onPressed: () {
                setState(() {
                  currentPage = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
                if (currentPage > 1) {
                  setState(() {
                    currentPage--;
                  });
                }
              },
            ),
            Text(currentPage > 1 ? (currentPage - 1).toString() : ''),
            Text(
              currentPage.toString(),
              style: TextStyle(color: main_color),
            ),
            Text(currentPage < totalPages ? (currentPage + 1).toString() : ''),
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
      ),
    );
  }
}

class CustomerTable extends StatelessWidget {
  final dynamic customer;
  final Function() onTap;

  CustomerTable({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String shortAddress = _getShortAddress(customer['address']);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Table(
        border: TableBorder.all(
            width: 1.0,
            color: modal_disabled,
            borderRadius: BorderRadius.circular(5)),
        columnWidths: {
          0: FixedColumnWidth(app_width * 0.2),
          1: FixedColumnWidth(app_width * 0.2),
          2: FixedColumnWidth(app_width * 0.2),
          3: FlexColumnWidth()
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              height: app_height * 0.05,
              alignment: Alignment.center,
              child: Text(customer['customerType'] ?? '-'),
            ),
            Container(
              height: app_height * 0.05,
              alignment: Alignment.center,
              child: Text(customer['name'] ?? '-'),
            ),
            Container(
              height: app_height * 0.05,
              alignment: Alignment.center,
              child: Text(customer['age'].toString() ?? '-'),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                height: app_height * 0.05,
                alignment: Alignment.center,
                child: Text(shortAddress),
              ),
            )
          ]),
        ],
      ),
    );
  }

  String _getShortAddress(String? address) {
    if (address == null || address.isEmpty) return '-';
    if (address.length > 15) return address.substring(0, 10) + '...';
    return address;
  }
}