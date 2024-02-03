import 'package:flutter/material.dart';

class CardInfoScorer extends StatefulWidget {
  const CardInfoScorer({super.key});

  @override
  State<CardInfoScorer> createState() => _CardInfoScorerState();
}

class _CardInfoScorerState extends State<CardInfoScorer> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Center(
            child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.only(right: 0),
                            ),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assests/csk.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ), // Team 1 Avatar
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'CSK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                              width: double.infinity,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                '197-5',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                '18.2 OVERS',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        )), // Team 1 score
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                child: Text(
                                  'RCB',
                                  style: TextStyle(
                                      color: Color(0xff9b9b9b), fontSize: 12),
                                  textAlign: TextAlign.end,
                                ),
                                width: double.infinity,
                              ),
                              Container(
                                width: double.infinity,
                                child: Text('225-5',
                                    style: TextStyle(
                                        color: Color(0xff9b9b9b),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end),
                              ),
                              Container(
                                width: double.infinity,
                                child: Text('20.0 OVERS',
                                    style: TextStyle(
                                        color: Color(0xff9b9b9b), fontSize: 12),
                                    textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ), // Team 2 Score
                        Expanded(
                          child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.only(right: 0),
                            ),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assests/rcb.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ), // Team 2 Avatar
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: 'Need '),
                          TextSpan(
                              text: '28 runs ',
                              style: TextStyle(color: Colors.red)),
                          TextSpan(text: 'from '),
                          TextSpan(
                              text: '10 balls',
                              style: TextStyle(color: Colors.red)),
                        ]),
                  ),
                )),

          ],
        )));
  }
}
