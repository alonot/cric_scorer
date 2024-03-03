

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
    return PopScope(canPop: false,
    onPopInvoked: (val){
      Navigator.pushNamedAndRemoveUntil(context, Util.mainPageRoute,(route) => false);
    }
    ,child:Container(
          decoration: const BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: const Color(0x89000000),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage("assests/trophy.jpg")),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: Util.team,style: const TextStyle(color: Colors.red)),
                          const TextSpan(text: " won by ",style: TextStyle(color: Colors.white)),
                          TextSpan(text: Util.wonBy,style: const TextStyle(color: Colors.red)),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          )),);
  }
}
