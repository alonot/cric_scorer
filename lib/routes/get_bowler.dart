import 'package:cric_scorer/Components/auto_complete_it.dart';
import 'package:cric_scorer/Components/card_bowler.dart';
import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/models/bowler.dart';
import 'package:cric_scorer/models/match.dart';
import 'package:cric_scorer/models/over.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class GetBowler extends StatefulWidget {
  const GetBowler({super.key});

  @override
  State<GetBowler> createState() => _GetBowlerState();
}

class _GetBowlerState extends State<GetBowler> {
  final MatchViewModel viewModel = MatchViewModel();
  String bowlerName = "";
  List<Bowler> bowlers = [];
  TheMatch? match;

  void selectBowler(Bowler? bowler) async {
    match ??= viewModel.getCurrentMatch();
    if (bowler != null) {
      if (match!.currentBowler!.name == bowler.name) {
        ScaffoldMessenger.of(context).showSnackBar(
            Util.getsnackbar('Prev Over was bowled by this bowler.'));
        return;
      }
      setState(() {
        match!.currentBowler = bowler;
        match!.Overs[match!.currentTeam].add(Over(
          match!.over_count[match!.currentTeam].toInt(),
          bowler.name,
          [match!.currentBatters[match!.currentBatterIndex].name],
        ));
      });
      // await viewModel.updateMatch(match!);
      Navigator.pop(context);
    }
  }

  void onPlayBtnClicked() async {
    if (bowlerName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar('Name Cannot be Empty.'));
      return;
    }

    // Check for same bowler
    for (Bowler b in match!.bowlers[match!.currentTeam]) {
      if (b.name == bowlerName) {
        ScaffoldMessenger.of(context)
            .showSnackBar(Util.getsnackbar('Duplicate Bowler'));
      }
    }

    Bowler bowler = Bowler(bowlerName); // Adding the new Bowler
    setState(() {
      match!.addBowler(bowler);
      // Adding a new Over
      match!.Overs[match!.currentTeam].add(Over(
        match!.over_count[match!.currentTeam].toInt(),
        bowler.name,
        [match!.currentBatters[match!.currentBatterIndex].name],
      ));
    });
    Navigator.pop(context);
  }

  void setBowlerName(String val) => bowlerName = val;

  @override
  Widget build(BuildContext context) {
    match = viewModel.getCurrentMatch();
    if (match != null) {
      setState(() {
        bowlers = match!.bowlers[match!.currentTeam];
      });
    }

    return Scaffold(
      key: const Key("GetBowler"),
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: const BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: Column(
              children: [
                Card(
                  elevation: 20,
                  color: Colors.transparent,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text('Next Bowler',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                          AutoCompleteIt(
                            Util.bowlerNames,
                            setBowlerName,
                            key: const Key("Get Bowler Auto"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CardBowler(
                  bowlers,
                  onTap: selectBowler,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onPlayBtnClicked();
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
              ],
            )),
          )),
    );
  }
}
