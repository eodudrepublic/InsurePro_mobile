import 'package:flutter/material.dart';

class CustomerDetail extends StatefulWidget {
  final int customerPk;
  const CustomerDetail({super.key, required this.customerPk});

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  late int _customerPk;

  @override
  void initState() {
    super.initState();
    _customerPk = widget.customerPk;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
