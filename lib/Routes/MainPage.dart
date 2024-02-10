

import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Match> matches = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        border: null,
        image: DecorationImage(
        image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
    ),
    child: Scaffold(
    backgroundColor: Color(0x89000000),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, Util.homeRoute);
        },child: Center(child: Icon(Icons.add),),
      ),
      body: ListView(
        children: <Widget>[],
      ),
    ));
  }
}
