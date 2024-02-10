import 'package:cric_scorer/Components/forMatch/CardBatter.dart';
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class GetWicket extends StatefulWidget {
  const GetWicket({super.key});

  @override
  State<GetWicket> createState() => _GetWicketState();
}

class _GetWicketState extends State<GetWicket> {
  TextEditingController battercntrl = TextEditingController();
  TextEditingController helpercntrl = TextEditingController();
  List<String> batters = [];
  List<Batter> retiredBatters = [];
  late TheMatch? match;
  String wicketType = 'Bowled';
  String batterOut = '';
  bool showhelper = false;
  bool isMatchOver = false;
  String score = "0";
  String wickets = "0";
  String overs = "0.0";

  void HandleWicket() {
    if (showhelper) {
      print("Yes" + helpercntrl.text);
      if (helpercntrl.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(Util.getsnackbar('Fields must not be empty'));
        return;
      }
    }
    if (match != null) {
      print("yes");
      Batter? batter;
      for (Batter b in match!.currentBatters) {
        if (b.name == batterOut) {
          batter = b;
          break;
        }
      }
      switch (wicketType) {
        case "Hit Wicket":
          batter!.outBy = 'Hit Wicket';
          break;
        case "LBW":
          batter!.outBy = 'LBW ';
          break;
        case "Stumping":
          batter!.outBy = 'St ${helpercntrl.text} ';
          break;
        case "Catch Out":
          batter!.outBy = 'c ${helpercntrl.text}';
          break;
        case 'Run out':
          batter!.outBy = 'run out (${helpercntrl.text})';
          break;
      }
      if (wicketType != "Run Out") {
        batter!.outBy += 'b ${match!.currentBowler}';
      }
      match!.wicketOrder.add(batter!);
      debugPrint(match!.currentBatters[0].name);
      match!.currentBatters.remove(batter);
      debugPrint(match!.currentBatters[0].name);
    }
  }

  void onTap(Batter b) {
    final match = this.match;
    if (match != null) {
      HandleWicket();
      b.outBy = '';
      match.currentBatters.add(b);
      match!.currentBatters = List.of(match!.currentBatters.reversed);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Util.viewModel;
    if (viewModel != null) {
      this.match = viewModel.getCurrentMatch();
      final match = this.match;
      if (match != null) {
        batters = [match.currentBatters[0].name, match.currentBatters[1].name];
        batterOut = batters[0];
        retiredBatters = [];
        isMatchOver = match.hasWon;
        score = match.score[match.currentTeam].toString();
        wickets = match.wickets[match.currentTeam].toString();
        overs = match.over_count[match.currentTeam].toStringAsFixed(1);
        for (Batter b in match.batters[match.currentTeam]) {
          if (b.outBy == "Retired Out") {
            retiredBatters.add(b);
          }
        }
      }
    }

    var focusNextBatter = FocusNode();

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: Key("Get Wicket Scaffold"),
        backgroundColor: Colors.transparent,
        body: Container(
            decoration: BoxDecoration(
              border: null,
              image: DecorationImage(
                  image: AssetImage('assests/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Container(
                      key: Key("popo"),
                      child: Card(
                        elevation: 20,
                        color: Colors.transparent,
                        shadowColor: Colors.black,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.0),
                                    child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(text: 'Socre : '),
                                          TextSpan(
                                              text: score + "-" + wickets,
                                              style: TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: " : " + overs + ' OVERS',
                                              style:
                                              TextStyle(color: Colors.blueGrey))
                                        ])),
                                  ),
                                )),
                            Container(
                              key: Key("0"),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    ListTile(
                                      title: Text(
                                        'Bowled',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "Bowled",
                                        onChanged: (val) {
                                          setState(() {
                                            wicketType = val!;
                                            showhelper = false;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Hit Wicket',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "Hit wicket",
                                        onChanged: (val) {
                                          setState(() {
                                            wicketType = val!;
                                            showhelper = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    ListTile(
                                      title: Text(
                                        'Run out',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "Run out",
                                        onChanged: (val) {
                                          setState(() {
                                            wicketType = val!;
                                            showhelper = true;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Catch Out',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "Catch out",
                                        onChanged: (val) {
                                          setState(() {
                                            showhelper = true;
                                            wicketType = val!;
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    ListTile(
                                      title: Text(
                                        'LBW',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "LBW",
                                        onChanged: (val) {
                                          setState(() {
                                            showhelper = false;
                                            wicketType = val!;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Stumping',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: wicketType,
                                        value: "Stumping",
                                        onChanged: (val) {
                                          setState(() {
                                            wicketType = val!;
                                            showhelper = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                'Who Got Out?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                      child: ListTile(
                                        title: Text(
                                          batters[0],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: batterOut,
                                          value: batters[0],
                                          onChanged: (val) {
                                            setState(() {
                                              if (val != null) {
                                                batterOut = batters[0];
                                              }
                                            });
                                          },
                                        ),
                                      )),
                                  Container(
                                    child: ListTile(
                                      title: Text(
                                        batters[1],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Radio<String>(
                                        groupValue: batterOut,
                                        value: batters[1],
                                        onChanged: (val) {
                                          setState(() {
                                            if (val != null) {
                                              batterOut = batters[1];
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: showhelper
                                  ? TextField(
                                controller: helpercntrl,
                                textAlign: TextAlign.start,
                                onEditingComplete: (){
                                  FocusScope.of(context).requestFocus(focusNextBatter);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Who Helped',
                                    labelStyle:
                                    TextStyle(color: Colors.white)),
                              )
                                  : SizedBox(
                                width: 0,
                                height: 0,
                              ),
                            ),
                            Container(
                              child: !isMatchOver
                                  ? TextField(
                                controller: battercntrl,
                                textAlign: TextAlign.start,
                                focusNode: focusNextBatter,
                                decoration: InputDecoration(
                                    labelText: 'Next Batter',
                                    labelStyle:
                                    TextStyle(color: Colors.white)),
                              )
                                  : SizedBox(width: 0, height: 0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: CardBatter(
                        retiredBatters,
                        false,
                        onTap,
                        key: Key("Unique"),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint("Lets Continue > Got Wicket!!");
                              if (battercntrl.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Util.getsnackbar(
                                        'Fields must not be empty'));
                                return;
                              }
                              HandleWicket();
                              Batter? batter;
                              batter = Batter(battercntrl.text);
                              match!.addBatter(batter);
                              match!.currentBatters =
                                  List.of(match!.currentBatters.reversed);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Let's Play!!",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0x42A4E190))),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              )),
            )),
      ),
    );
  }
}
