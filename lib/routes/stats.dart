import 'package:cric_scorer/Components/stat/card_batter_stat.dart';
import 'package:cric_scorer/Components/stat/card_bowler_stat.dart';
import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/models/batter_stat.dart';
import 'package:cric_scorer/models/bowler_stat.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final MatchViewModel viewModel = MatchViewModel();
  List<BatterStat> batters = [];
  List<BowlerStat> bowlers = [];
  int isSelected = 0;
  String toDisplay = "1st innings";
  bool isLoading = false;
  List<int> associatedIds = playArenaIds.keys.toList();
  int selectedId = 0;

  @override
  void initState() {
    selectedId = associatedIds[0];
    getPlayers();
    super.initState();
  }

  void getPlayers() async {
    isLoading = true;
    batters = await viewModel.getBatters(true,id : selectedId);
    bowlers = await viewModel.getBowlers(true,id : selectedId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: null,
        image: DecorationImage(
            image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  const Color(0x89000000),
          leading: SizedBox(width: 100,
            height: 20,
            child: DropdownButton<int>(
              icon: const Icon(Icons.sort_rounded),
              elevation: 20,
              value: selectedId,
              underline: Container(),
              items: associatedIds
                  .map((id) => DropdownMenuItem(
                value: id,
                child: Text(" $id    ",style: TextStyle(color: Colors.red),),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedId = value!;
                });
              },
            ),
          ),
        ),
        backgroundColor: const Color(0x89000000),
        body: Stack(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox(width: 0, height: 0),
            !isLoading
                ? Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListView(
                children: [
                  const ListTile(
                    title: Text(
                      "Stats",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                  ),
                  Column(
                    children: [
                      ListTile(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey)),
                        onTap: () {
                          setState(() {
                            isSelected = 0;
                          });
                        },
                        tileColor: isSelected == 1
                            ? Colors.transparent
                            : Colors.grey,
                        title: const Text(
                          "Batters",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      isSelected == 0
                          ? CardBatterStat(batters)
                          : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey)),
                        onTap: () {
                          setState(() {
                            isSelected = 1;
                          });
                        },
                        tileColor: isSelected == 0
                            ? Colors.transparent
                            : Colors.grey,
                        title: const Text(
                          "Bowlers",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      isSelected == 1
                          ? CardBowlerStat(bowlers)
                          : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    ],
                  ),
                ],
              ),
            )
                : const SizedBox(
              width: 0,
              height: 0,
            ),
          ],
        ),
      ),
    ) ;
  }
}
