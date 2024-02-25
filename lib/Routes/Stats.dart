import 'package:cric_scorer/Components/forStat/CardBatterStat.dart';
import 'package:cric_scorer/Components/forStat/CardBowlerStat.dart';
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/BatterStat.dart';
import 'package:cric_scorer/models/BowlerStat.dart';
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

  _StatsState(){
    getPlayers();
  }


  void getPlayers() async{
      isLoading = true;
    batters = await viewModel.getBatters();
    bowlers = await viewModel.getBowlers();
    setState(() {
        isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {


    return SafeArea(
        top: true,
        minimum: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          decoration: const BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: const Color(0x89000000),
            body: Stack(
              children: [
                isLoading ? const Center(child:CircularProgressIndicator()):const SizedBox(width:0,height: 0),
                !isLoading ?  Padding(
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
                            tileColor:
                            isSelected == 1 ? Colors.transparent : Colors.grey,
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
                            tileColor:
                            isSelected == 0 ? Colors.transparent : Colors.grey,
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
                ):const SizedBox(width: 0,height: 0,),
              ],
            ),
          ),
        ));
  }
}
