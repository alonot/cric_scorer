

import 'package:cric_scorer/Components/CardBalls.dart';
import 'package:cric_scorer/Components/CardBatter.dart';
import 'package:cric_scorer/Components/CardBowler.dart';
import 'package:cric_scorer/Components/CardInfoScorer.dart';
import 'package:cric_scorer/Components/CardScorer.dart';
import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
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
              child: CardInfoScorer(),
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 50,
              child: CardBalls(),
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 130,
              child: CardBatter(),
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 130,
              child: CardBowler(),
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              height: 200,
              child: CardScorer(),
            ),

          ],
        ),
      ),
    );
  }
}
