
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  String val1 = "";
  String val2 = "";
  _CardInfoState? _state;
  final void Function(String t1, String t2) update;

  CardInfo(this.update, this.val1, this.val2, {super.key}){
    // debugPrint("Calse");
    _state = _CardInfoState(
      val1,
      val2
    );
  }

  @override
  State<CardInfo> createState() => _state!;

  Map<String, String> getInfo() => _state!.getRequiredInfo();
}

class _CardInfoState extends State<CardInfo> {
  TextEditingController team1cntrl = TextEditingController();
  TextEditingController team2cntrl = TextEditingController();
  String _team1Url = "assests/CSK.jpg";
  String _team2Url = "assests/RCB.jpg";

  _CardInfoState(String val1,String val2) {
    _team1Url = "assests/${val1}.jpg";
    team1cntrl.text = val1;
    _team2Url = "assests/${val2}.jpg";
    team2cntrl.text = val2;
    // debugPrint("$val1 fd $val2");
  }

  void changeTeam(bool change1,bool change2) {
    logos = logos.sublist(1) + [logos[0]];
    if (change1) {
      _team1Url = "assests/${logos[0]}.jpg";
      team1cntrl.text = logos[0];
    }
    if (change2) {
      _team2Url = "assests/${logos[1]}.jpg";
      team2cntrl.text = logos[1];
    }
    widget.val1 = team1cntrl.text;
    widget.val2 = team2cntrl.text;

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
                      setState(() {
                        changeTeam(true,false);
                      });
                      widget.update(team1cntrl.text,team2cntrl.text);
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
                      setState(() {
                        changeTeam(false, true);
                        widget.update(team1cntrl.text,team2cntrl.text);
                      });
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
                            image: AssetImage(_team2Url ), fit: BoxFit.cover),
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
