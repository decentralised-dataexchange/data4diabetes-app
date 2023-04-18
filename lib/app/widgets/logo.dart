import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  static const double imageHeight = 100;


  Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/blood_drop.png', height:imageHeight, fit: BoxFit.cover),

         const Text(
          'Data4Diabetes',
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Arial',color: Colors.grey),
        ),

      ],
    );
  }
}
