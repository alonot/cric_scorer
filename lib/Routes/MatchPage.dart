
import 'package:cric_scorer/Components/CardBowler.dart';
import 'package:cric_scorer/Components/forMatch//CardInfoScorer.dart';
import 'package:cric_scorer/Components/forMatch//CardScorer.dart';
import 'package:cric_scorer/Components/forMatch/CardBalls.dart';
import 'package:cric_scorer/Components/forMatch/CardBatter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  var viewModel = Util.viewModel;
  TheMatch? match;
  bool isLoading = false;

  _MatchPageState() {
    if (viewModel != null) {
      match = viewModel!.getCurrentMatch()!;
    }
  }

  void swap() {
    setState(() {
      match!.currentBatters = List.of(match!.currentBatters.reversed);
    });
  }

  void retire() async{
    // retire the batter
    // match?.wickets[match!.currentTeam] +=1;
    await Navigator.pushNamed(context, "Get Batter")
        .then((value) => {setState(() {})});
  }

  void endInning() {
    // TODO : To end the inning
  }

  void updateScore(String s, String run) async {
    bool needABowler = false;
    isLoading = true;
    setState(() {
      needABowler = match!.addScore(s, run);
    });
    if (run.contains("OUT")) {
      match!.wickets[match!.currentTeam] += 1;
    }
    if(match!.inning == 2){
      var cur = match!.currentTeam;
      if (match!.score[cur] == match!.score[(cur+1)%2]){
        // TODO : Display Winning message
      }
    }
    if (match!.over_count[match!.currentTeam] >= match!.totalOvers ||
        match!.wickets[match!.currentTeam] == match!.no_of_players - 1) {
      // Call the openers . change the current Team index;
      if(match!.inning == 1){
      match!.inning = 2;
      match!.currentTeam++;
      match!.currentTeam %= 2;
        await Navigator.pushNamedAndRemoveUntil(context, "Get Openers",(route){ debugPrint(route.settings.name);return false;})
            .then((value) => setState(() {}));
      }
    } else if (run.contains("OUT")) {
      await Navigator.pushNamed(context, "Wicket")
          .then((value) => {setState(() {})});
    }

    if (needABowler) {
      await Navigator.pushNamed(context, "Get Bowler")
          .then((value) => {setState(() {})});
    }
    isLoading = false;
  }

  void popScore() {
    isLoading = true;
    setState(() {
      bool result = match!.popScore();
      debugPrint(result.toString());
      if (result) {
        goBack();
      }
    });
    isLoading = false;
  }

  void goBack() {
    Navigator.pushNamedAndRemoveUntil(context, "New Match", (route) {
      print(route.settings.name);
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          debugPrint(didPop.toString());
          debugPrint("ue");
          goBack();
        },
        child: Container(
          decoration: BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            key: Key("MatchPage"),
            backgroundColor: Color(0x89000000),
            body: Padding(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 15),
              child: ListView(
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
                    height: 65,
                    child: CardBalls(
                      key: Key("K2"),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 130,
                    child: CardBatter(match!.currentBatters,true,null,
                        key: const Key("MatchPageBatter")),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 100,
                    child: CardBowler([match!.currentBowler!],
                        key: const Key("MatchPageBowler")),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 200,
                    child: CardScorer(
                        updateScore, popScore, swap, retire, endInning,
                        key: Key("Score1")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
