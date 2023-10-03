import 'package:flutter/cupertino.dart';

class InsureProLogo extends StatelessWidget {
  const InsureProLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'InsurePro',
        style: TextStyle(
          color: Color(0xFF175CD3),
          fontSize: 28,
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.18,
        ),
      ),
    );
  }
}