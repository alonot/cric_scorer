import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({super.key});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Center(
          child: Row(children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint("helo");
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.only(right: 0)),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assests/csk.jpg'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: GestureDetector(
                      child: Text(
                        "Team 1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Roboto'),
                      ),
                      onTap: () {
                        debugPrint("Helllo");
                      },
                    ))
              ],
            )),
            Text(
              'V/S',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint("helo");
                        },
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.only(right: 0)),
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assests/rcb.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: GestureDetector(
                          child: Text(
                            "Team 2",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Roboto'),
                          ),
                          onTap: () {
                            debugPrint("Helllwo");
                          },
                        ))
                  ],
                )),
          ]),
        ));
  }
}
