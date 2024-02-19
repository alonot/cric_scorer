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
    batters = await viewModel.getStat();
    bowlers = await viewModel.getBowlers();
    setState(() {
        isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {


    return SafeArea(
        top: true,
        minimum: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Color(0x89000000),
            body: Stack(
              children: [
                isLoading ? Center(child:CircularProgressIndicator()):SizedBox(width:0,height: 0),
                !isLoading ?  Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ListView(
                    children: [
                      ListTile(
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
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey)),
                            onTap: () {
                              setState(() {
                                isSelected = 0;
                              });
                            },
                            tileColor:
                            isSelected == 1 ? Colors.transparent : Colors.grey,
                            title: Text(
                              "Batters",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          isSelected == 0
                              ? CardBatterStat(batters)
                              : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey)),
                            onTap: () {
                              setState(() {
                                isSelected = 1;
                              });
                            },
                            tileColor:
                            isSelected == 0 ? Colors.transparent : Colors.grey,
                            title: Text(
                              "Bowlers",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          isSelected == 1
                              ? CardBowlerStat(bowlers)
                              : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ):SizedBox(width: 0,height: 0,),
              ],
            ),
          ),
        ));
  }
}
