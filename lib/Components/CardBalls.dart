

import 'package:flutter/material.dart';

class CardBalls extends StatefulWidget {
  const CardBalls({super.key});

  @override
  State<CardBalls> createState() => _CardBallsState();
}

class _CardBallsState extends State<CardBalls> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0,right: 20.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
                // color: Colors.red,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                ),
                child: Center(
                  child: Text("6"),
                ),
              )
            ],
          ),
        )
    );
  }
}
