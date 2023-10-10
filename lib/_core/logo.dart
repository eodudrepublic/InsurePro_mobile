import 'package:flutter/cupertino.dart';
import 'package:insurepro_mobile/_core/app_color.dart';

class InsureProLogo extends StatelessWidget {
  const InsureProLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'InsurePro',
        style: TextStyle(
          color: main_color,
          fontSize: 28,
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.18,
        ),
      ),
    );
  }
}