

import 'package:cric_scorer/Components/CardBatter.dart';
import 'package:cric_scorer/Components/CardBowler.dart';
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:flutter/material.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  final MatchViewModel viewModel =  MatchViewModel();
  List<Batter> battersTeam1 = [];
  List<Batter> battersTeam2 = [];
  List<Bowler> bowlersTeam1 = [];
  List<Bowler> bowlersTeam2 = [];
  String team1="";
  String team2="";
  String score1="0-0";
  String score2 = "0-0";
  String overs1 = "0.0";
  String overs2 = "0.0";
  int isSelected = 0;



  @override
  Widget build(BuildContext context) {
    TheMatch match = viewModel.getCurrentMatch()!;
    battersTeam1 = match.batters[0];
    battersTeam2 = match.batters[1];
    bowlersTeam1 = match.bowlers[0];
    bowlersTeam2 = match.bowlers[1];
    team1 = match.team1;
    team2 = match.team2;
    score1 = "${match.score[0]}-${match.wickets[0]}";
    score2 = "${match.score[1]}-${match.wickets[1]}";
    overs1 = "${match.over_count[0]} OVERS";
    overs2 = "${match.over_count[1]} OVERS";


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
        body: Padding(
          padding: EdgeInsets.only(top:50 ),
          child: ListView(
            children: [
              Text("ScoreCard",style: TextStyle(color: Colors.blueGrey,fontSize: 22,),textAlign: TextAlign.center,),
              Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey
                      )
                    ),
                    onTap: (){
                      setState(() {
                        isSelected = 0;
                      });
                    },
                    tileColor: isSelected == 1 ? Colors.transparent :Colors.grey,
                    leading: Text(team1,style: TextStyle(color: Colors.white,fontSize: 15),),
                    title: Text(score1,style: TextStyle(color: Colors.white),),
                    trailing: Text(overs1,style: TextStyle(color: Colors.white),),
                  ),
                  isSelected == 0 ? CardBatter(battersTeam1, false, (p0) => null):SizedBox(width: 0 ,height: 0,),
                  isSelected == 0 ? CardBowler(bowlersTeam1):SizedBox(width: 0 ,height: 0,),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey
                        )
                    ),
                    onTap: (){
                      setState(() {
                        isSelected = 1;
                      });
                    },
                    tileColor: isSelected == 0 ? Colors.transparent :Colors.grey,
                    leading: Text(team2,style: TextStyle(color: Colors.white,fontSize: 15),),
                    title: Text(score2,style: TextStyle(color: Colors.white),),
                    trailing: Text(overs2,style: TextStyle(color: Colors.white),),
                  ),
                  isSelected == 1 ?
                  CardBatter(battersTeam2, false, (p0) => null):SizedBox(width: 0,height: 0,),
                  isSelected == 1 ? CardBowler(bowlersTeam2):SizedBox(width: 0,height: 0,),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}