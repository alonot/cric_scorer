import 'package:cric_scorer/Components/CardBowler.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/models/Over.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class GetBowler extends StatefulWidget {
  const GetBowler({super.key});

  @override
  State<GetBowler> createState() => _GetBowlerState();
}

class _GetBowlerState extends State<GetBowler> {
  final MatchViewModel viewModel = MatchViewModel();
  TextEditingController bowlercntrl = TextEditingController();
  List<Bowler> bowlers = [];
  TheMatch? match;

  void selectBowler(Bowler? bowler) async {
    if (match == null) {
        match = viewModel.getCurrentMatch();
    }
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
      await viewModel.updateMatch(match!);
        Navigator.pop(context);
    }
  }

  void onPlayBtnClicked() async {
    // TODO : check for same name
    if (bowlercntrl.text.isEmpty) {
      debugPrint("her");
      ScaffoldMessenger.of(context).showSnackBar(
          Util.getsnackbar('Name Cannot be Empty.'));
      return;
    }
    Bowler bowler =
    Bowler(bowlercntrl.text); // Adding the new Bowler
    setState(() {
      match!.addBowler(bowler);
      // Adding a new Over
      match!.Overs[match!.currentTeam].add(Over(
        match!.over_count[match!.currentTeam].toInt(),
        bowler.name,
        [match!.currentBatters[match!.currentBatterIndex].name],
      ));
    });
    await viewModel.updateMatch(match!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
      match = viewModel.getCurrentMatch();
      if (match != null) {
        setState(() {
          bowlers = match!.bowlers[match!.currentTeam];
        });
    }

    return Scaffold(
      key: Key("GetBowler"),
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: const BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
                child: Column(
                  children: [
                    Card(
                      elevation: 20,
                      color: Colors.transparent,
                      shadowColor: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextField(
                                controller: bowlercntrl,
                                textAlign: TextAlign.start,
                                inputFormatters: [
                                  FilteringTextInputFormatter.singleLineFormatter
                                ],
                                enableSuggestions: true,
                                decoration: const InputDecoration(
                                    labelText: 'Next Bowler',
                                    labelStyle: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CardBowler(
                      bowlers,
                      OnTap: selectBowler,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: ()  {
                            onPlayBtnClicked();
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
                )),
          )),
    );
  }
}
