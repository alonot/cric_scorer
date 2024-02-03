import 'package:cric_scorer/Components/CardInfo.dart';
import 'package:cric_scorer/Components/CardMatchSettings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x89000000),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 15),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 180,
              child: CardInfo(),
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 280,
              child: CardMatchSettings(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("Lets Play!!");
                  },
                  child: Text(
                    "Let's Play!!",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0x42A4E190))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
