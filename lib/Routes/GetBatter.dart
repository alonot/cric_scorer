import 'package:cric_scorer/Components/CardBatter.dart';
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class GetBatter extends StatefulWidget {
  const GetBatter({super.key});

  @override
  State<GetBatter> createState() => _GetBatterState();
}

class _GetBatterState extends State<GetBatter> {
  final MatchViewModel viewModel = MatchViewModel();
  TextEditingController battercntrl = TextEditingController();
  List<Batter> retiredBatters = [];
  TheMatch? match;
  String score = "0";
  String wickets = "0";
  String overs = "0.0";

  void onTap(Batter b) async {
    final match = this.match;
    if (match != null) {
      match.currentBatters[match.currentBatterIndex].outBy = 'Retired Out';
      match.wicketOrder[match.currentTeam].add([match.currentBatters[match.currentBatterIndex],"$overs\t\t $score-$wickets"]);
      match.currentBatters.removeAt(match.currentBatterIndex);
      b.outBy = 'Not Out';
      match.currentBatters.add(b);
      await viewModel.updateMatch(match);
      match.currentBatters = List.of(match.currentBatters.reversed);
      Navigator.pop(context);
    }
  }

  void onPlayBtnClick() async {
    debugPrint("Lets Play!!");
    TheMatch? match = viewModel.getCurrentMatch();
    if (match != null) {
      match.currentBatters[match.currentBatterIndex].outBy = 'Retired Out';
      match.wicketOrder[match.currentTeam].add([match.currentBatters[match.currentBatterIndex],"$overs\t\t $score-$wickets"]);
      match.currentBatters.removeAt(match.currentBatterIndex);
      // debugPrint(match.currentBatters[0].toString());
      match.addBatter(Batter(battercntrl.text));
      match.currentBatters = List.of(match.currentBatters.reversed);

      await viewModel.updateMatch(match);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var match = viewModel.getCurrentMatch();
    if (match != null) {
      retiredBatters = [];
      score = match!.score[match!.currentTeam].toString();
      wickets = match!.wickets[match!.currentTeam].toString();
      overs = match!.over_count[match!.currentTeam].toStringAsFixed(1);
      for (Batter b in match!.batters[match!.currentTeam]) {
        if (b.outBy == "Retired Out") {
          retiredBatters.add(b);
        }
      }
    }


    return PopScope(canPop: false, child: Container(
        decoration: BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
                child: Column(
                  children: [Card(
                    elevation: 20,
                    color: Colors.transparent,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 120,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextField(
                              controller: battercntrl,
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                  labelText: 'New Batter',
                                  labelStyle: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'Socre : '),
                                    TextSpan(
                                        text: score + "-" + wickets,
                                        style: TextStyle(color: Colors.red)),
                                    TextSpan(
                                        text: overs + ' OVERS',
                                        style: TextStyle(
                                            color: Colors.blueGrey))
                                  ])),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                    CardBatter(retiredBatters, false, onTap,false)
                    , Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            onPlayBtnClick();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0x42A4E190))),
                          child: const Text(
                            "Let's Play!!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )

            )
        )),);
  }

}
