import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  final _CardInfoState _state = _CardInfoState();
  final void Function(String t1, String t2) update;

  CardInfo(this.update, {super.key});

  @override
  State<CardInfo> createState() => _state;

  Map<String, String> getInfo() => _state.getRequiredInfo();
}

class _CardInfoState extends State<CardInfo> {
  TextEditingController team1cntrl = TextEditingController();
  TextEditingController team2cntrl = TextEditingController();
  String _team1Url = "assests/csk.jpg";
  String _team2Url = "assests/rcb.jpg";

  _CardInfoState() {
    team1cntrl.text = "Team 1";
    team2cntrl.text = "Team 2";
  }

  Map<String, String> getRequiredInfo() => Map.of({
        "team1": team1cntrl.text,
        "team1Url": _team1Url,
        "team2": team2cntrl.text,
        "team2Url": _team2Url
      });

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
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.only(right: 0)),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(_team1Url), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: EditableText(
                      onChanged: (val) {
                        widget.update(team1cntrl.text, team2cntrl.text);
                      },
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Roboto'),
                      controller: team1cntrl,
                      focusNode: FocusNode(),
                      cursorColor: Colors.blueGrey,
                      backgroundCursorColor: Colors.blue,
                    ))
              ],
            )),
            const Text(
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
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.only(right: 0)),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(_team2Url), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: EditableText(
                      onChanged: (val) {
                        widget.update(team1cntrl.text, team2cntrl.text);
                      },
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Roboto'),
                      controller: team2cntrl,
                      focusNode: FocusNode(),
                      cursorColor: Colors.blueGrey,
                      backgroundCursorColor: Colors.blue,
                    ))
              ],
            )),
          ]),
        ));
  }
}
