import 'package:cric_scorer/Components/CardBowler.dart';
import 'package:cric_scorer/Components/forMatch//CardInfoScorer.dart';
import 'package:cric_scorer/Components/forMatch//CardScorer.dart';
import 'package:cric_scorer/Components/forMatch/CardBalls.dart';
import 'package:cric_scorer/Components/CardBatter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final MatchViewModel viewModel = MatchViewModel();
  TheMatch? match;
  bool isLoading = false;

  _MatchPageState(){
    match = viewModel.getCurrentMatch();
  }

  void swap() async{
    setState(() {
      isLoading =true;
      match!.currentBatters = List.of(match!.currentBatters.reversed);
    });

    if (match != null) {
      await viewModel.updateMatch(match!);
    }
    setState(() {
      isLoading=false;
    });


  }

  void retire() async {
    // retire the batter
    // match?.wickets[match!.currentTeam] +=1;
    await Navigator.pushNamed(context, Util.getBatterRoute)
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
    if (match!.inning == 2) {
      var cur = match!.currentTeam;
      if (match!.score[cur] >= match!.score[(cur + 1) % 2]) {
        match!.hasWon = true;
        Util.team = cur == 0 ? match!.team1 : match!.team2;
        Util.wonBy =
            (match!.no_of_players - 1 - match!.wickets[cur]).toString();
        Navigator.pushNamed(context, Util.winnerPageRoute);
      } else if (match!.wickets[match!.currentTeam] ==
          match!.no_of_players - 1) {
        Util.team = cur == 0 ? match!.team2 : match!.team1;
        match!.hasWon = true;
        Util.wonBy =
            (match!.score[(cur + 1) % 2] - match!.score[cur] + 1).toString();
        Navigator.pushNamed(context, Util.winnerPageRoute);
      }
    }

    if (run.contains("OUT")) {
      await Navigator.pushNamed(context, Util.wicketRoute)
          .then((value) => {setState(() {})});
    }

    if (match!.over_count[match!.currentTeam] >= match!.totalOvers ||
        match!.wickets[match!.currentTeam] == match!.no_of_players - 1) {
      // Call the openers . change the current Team index;
      if (match!.inning == 1) {
        match!.inning = 2;
        match!.currentTeam++;
        match!.currentTeam %= 2;
        await Navigator.pushNamedAndRemoveUntil(context, Util.getOpenersRoute,
            (route) {
          debugPrint(route.settings.name);
          return false;
        }).then((value) => setState(() {}));
      } else {
        var cur = match!.currentTeam;
        if (match!.score[cur] >= match!.score[(cur + 1) % 2]) {
          Util.team = cur == 0 ? match!.team1 : match!.team2;
          Util.wonBy =
              (match!.no_of_players - 1 - match!.wickets[cur]).toString();
        } else {
          Util.team = cur == 0 ? match!.team2 : match!.team1;
          Util.wonBy =
              (match!.score[(cur + 1) % 2] - match!.score[cur] + 1).toString();
        }
        match!.hasWon = true;
        Navigator.pushNamed(context, Util.winnerPageRoute);
      }
    }

    if (needABowler) {
      await Navigator.pushNamed(context, Util.getBowlerRoute)
          .then((value) => {setState(() {})});
    }
    if (match != null) {
      debugPrint("heres");
      await viewModel.updateMatch(match!);
      debugPrint("jjsd");
    }

    setState(() {

      isLoading = false;
    });
  }

  void popScore() async {
    isLoading = true;
    setState(() {
      bool result = match!.popScore();
      debugPrint(result.toString());
      if (result) {
        goBack();
      }
    });
    if (match != null) {
      await viewModel.updateMatch(match!);
    }
    setState(() {
    isLoading = false;
    });
  }

  void goBack() {
    Navigator.pushNamedAndRemoveUntil(context, Util.homeRoute, (route) {
      debugPrint(route.settings.name);
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
          // debugPrint(didPop.toString());
          // debugPrint("ue");
          Navigator.pushNamedAndRemoveUntil(context, Util.mainPageRoute, (route) => false);
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
                  Flex(direction: Axis.vertical,
                  children: [CardInfoScorer(key : Key("K1") ),],
                  ),
                  Flex(
                    direction: Axis.vertical,
                    children: [CardBalls(
                      key: Key("K2"),
                    ),]
                  ),
                  CardBatter(match!.currentBatters, true, null,
                      key: const Key("MatchPageBatter")),
                  CardBowler([match!.currentBowler!],
                      key: const Key("MatchPageBowler")),
                  CardScorer(
                      updateScore, popScore, swap, retire, endInning,
                      key: Key("Score1")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
