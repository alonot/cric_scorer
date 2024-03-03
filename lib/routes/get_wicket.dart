import 'package:cric_scorer/Components/auto_complete_it.dart';
import 'package:cric_scorer/Components/card_batter.dart';
import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/models/batter.dart';
import 'package:cric_scorer/models/match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class GetWicket extends StatefulWidget {
  const GetWicket({super.key});

  @override
  State<GetWicket> createState() => _GetWicketState();
}

class _GetWicketState extends State<GetWicket> {
  final MatchViewModel viewModel = MatchViewModel();
  String batterName = "";
  TextEditingController helperName = TextEditingController();
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

  _GetWicketState() {
    this.match = viewModel.getCurrentMatch();
    final match = this.match;
    if (match != null) {
      batters = [match.currentBatters[0].name, match.currentBatters[1].name];
      retiredBatters = [];
      batterOut = batters[0];
      isMatchOver = match.hasWon ||
          match.over_count[match.currentTeam] == match.totalOvers ||
          match.wickets[match.currentTeam] == match.no_of_players - 1;
      debugPrint("Match:$isMatchOver");
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

  void handleWicket() async {
    if (showhelper) {
      // print("Yes" + helperName.text);
      if (helperName.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(Util.getsnackbar('Fields must not be empty'));
        return;
      }
    }
    if (match != null) {
      // print("yes");
      // Batter Already present or not
      Batter? batter;
      for (Batter b in match!.currentBatters) {
        if (b.name == batterOut) {
          batter = b;
          break;
        }
      }
      batter!.outBy = '';
      switch (wicketType) {
        case "Hit Wicket":
          batter.outBy = 'Hit Wicket';
          break;
        case "LBW":
          batter.outBy = 'LBW ';
          break;
        case "Stumping":
          batter.outBy = 'St ${helperName.text} ';
          break;
        case "Catch Out":
          batter.outBy = 'c ${helperName.text}';
          break;
        case 'Run out':
          batter.outBy = 'run out (${helperName.text})';
          break;
      }
      if (wicketType != "Run Out") {
        batter.outBy += 'b ${match!.currentBowler?.name}';
      }
      match!.wicketOrder[match!.currentTeam]
          .add([batter, "$overs\t\t $score-$wickets"]);
      match!.currentBatters.remove(batter);
    }
  }

  void onTap(Batter b) async {
    final match = this.match;
    if (match != null) {
      handleWicket();
      b.outBy = 'Not Out';
      match.currentBatters.add(b);
      match.currentBatters = List.of(match.currentBatters.reversed);
      // await viewModel.updateMatch(match);
      Navigator.pop(context);
    }
  }

  void setBatterName(String val) => batterName = val;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: const Key("Get Wicket Scaffold"),
        backgroundColor: Colors.transparent,
        body: Container(
            decoration: const BoxDecoration(
              border: null,
              image: DecorationImage(
                  image: AssetImage('assests/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Container(
                      key: const Key("pop"),
                      child: Card(
                        elevation: 20,
                        color: Colors.transparent,
                        shadowColor: Colors.black,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: RichText(
                                    text: TextSpan(children: [
                                  const TextSpan(text: 'Score : '),
                                  TextSpan(
                                      text: "$score-$wickets",
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  TextSpan(
                                      text: " : $overs OVERS",
                                      style: const TextStyle(
                                          color: Colors.blueGrey))
                                ])),
                              ),
                            ),
                            Container(
                              key: const Key("0"),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    ListTile(
                                      title: const Text(
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
                                      title: const Text(
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
                                      title: const Text(
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
                                      title: const Text(
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
                                      title: const Text(
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
                                      title: const Text(
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
                            const Text(
                              'Who Got Out?',
                              style: TextStyle(color: Colors.white),
                            ),
                            Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    batters[0],
                                    style: const TextStyle(color: Colors.white),
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
                                ),
                                ListTile(
                                  title: Text(
                                    batters[1],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  leading: Radio<String>(
                                    groupValue: batterOut,
                                    value: batters[1],
                                    onChanged: (val) {
                                      setState(() {
                                        debugPrint("BatterWicket $val");
                                        if (val != null) {
                                          batterOut = batters[1];
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: showhelper
                                  ? TextField(
                                      controller: helperName,
                                      textAlign: TextAlign.start,
                                      decoration: const InputDecoration(
                                          labelText: 'Who Helped',
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                    )
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                            ),
                            !isMatchOver
                                ? Column(children: [
                                    const Text(
                                      'Next Batter',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    AutoCompleteIt(
                                      Util.batterNames,
                                      setBatterName,
                                      key: const Key("Next Batter"),
                                    ),
                                  ])
                                : const SizedBox(width: 0, height: 0),
                          ],
                        ),
                      ),
                    ),
                    !isMatchOver
                        ? CardBatter(
                            retiredBatters,
                            false,
                            onTap,
                            false,
                            key: const Key("Unique"),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // To check for same name
                            for (Batter b
                                in match!.batters[match!.currentTeam]) {
                              if (b.name == batterName) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Util.getsnackbar('Duplicate Batter'));
                                return;
                              }
                            }
                            debugPrint("Lets Continue > Got Wicket!!");
                            if (!isMatchOver && batterName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Util.getsnackbar('Fields must not be empty'));
                              return;
                            }
                            handleWicket();
                            Batter? batter;
                            batter = Batter(batterName);
                            match!.addBatter(batter);
                            match!.currentBatters =
                                List.of(match!.currentBatters.reversed);
                            Util.batterNames.remove(batterName);
                            // await viewModel.updateMatch(match!);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0x42A4E190))),
                          child: const Text(
                            "Let's Play!!",
                            style: TextStyle(color: Colors.white),
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
