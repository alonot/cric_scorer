

import 'package:cric_scorer/utils/util.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class WinnerPage extends StatefulWidget {
  const WinnerPage({super.key});

  @override
  State<WinnerPage> createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(child:Center(
      child:  Container(
          decoration: BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Color(0x89000000),
            body: Center(
              child: Column(
                children: [
                  const Image(image: AssetImage("assests/trophy.jpg")),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: Util.team,style: TextStyle(color: Colors.red)),
                          TextSpan(text: " won by ",style: TextStyle(color: Colors.white)),
                          TextSpan(text: Util.wonBy,style: TextStyle(color: Colors.red)),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          )),
    ),canPop: false,
    onPopInvoked: (val){
      Navigator.pushNamedAndRemoveUntil(context, Util.mainPageRoute,(route) => false);
    },);
  }
}
