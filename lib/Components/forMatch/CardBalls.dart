
import 'package:cric_scorer/models/Match.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class CardBalls extends StatefulWidget {

  const CardBalls({super.key});

  @override
  State<CardBalls> createState() => _CardBallsState();
}

class _CardBallsState extends State<CardBalls> {
  List<dynamic> bowls = [];
  int count = 0;


  @override
  Widget build(BuildContext context) {
    var viewModel = MatchViewModel();
    TheMatch? match = viewModel.getCurrentMatch();
    if (match != null){
        if(match.Overs[match.currentTeam].isNotEmpty){
      setState(() {
         bowls = match.Overs[match.currentTeam].last.bowls;
         count = bowls.length;
         // debugPrint("$count, $bowls");
      });
        }
    }


    return  Card(
        elevation: 20,
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Center(
            key: Key("oo"),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 5),
              child:Container(
                child: ListView.builder(
                  itemCount: count,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    return Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2)
                      ,child: Container(
                          child: Center(
                            child: Column(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                // color: Colors.red,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Center(
                                  child: Text(bowls[index][0][0]),
                                ),
                              ),
                              bowls[index][1].isNotEmpty ?
                              Expanded(
                                child: Text(bowls[index][1],style: TextStyle(color: Colors.white,fontSize: 10),),
                              ) : SizedBox(width: 0,height: 0,)
                            ],
                          ),
                          )),);
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ) ,),
        ));
  }
}
