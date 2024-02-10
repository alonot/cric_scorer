import 'package:cric_scorer/Components/forMatch/CardBatter.dart';
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class GetBatter extends StatefulWidget {
  const GetBatter({super.key});

  @override
  State<GetBatter> createState() => _GetBatterState();
}

class _GetBatterState extends State<GetBatter> {
  TextEditingController battercntrl = TextEditingController();
  List<Batter> retiredBatters =[];
  TheMatch? match;
  String score = "0";
  String wickets = "0";
  String overs = "0.0";

  void onTap(Batter b){
    final match = this.match;
    if(match != null){
      b.outBy='';
      match.currentBatters.add(b);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel =Util.viewModel;
    if(viewModel != null){
      match = viewModel.getCurrentMatch();
      if(match != null){
        retiredBatters=[];
        score = match!.score[match!.currentTeam].toString();
        wickets = match!.wickets[match!.currentTeam].toString();
        overs = match!.over_count[match!.currentTeam].toStringAsFixed(1);
        for(Batter b in match!.batters[match!.currentTeam]){
          if (b.outBy == "Retired Out"){
            retiredBatters.add(b);
          }
        }
      }
    }
    return PopScope(canPop: false,child: Container(
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
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextField(
                              controller: battercntrl,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  labelText: 'New Batter',
                                  labelStyle: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'Socre : '),
                                    TextSpan(
                                        text: score+"-"+wickets, style: TextStyle(color: Colors.red)),
                                    TextSpan(
                                        text: overs+' OVERS',
                                        style: TextStyle(color: Colors.blueGrey))
                                  ])),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                    CardBatter(retiredBatters, false, onTap)
                    ,Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Lets Play!!");
                            var viewModel = Util.viewModel;
                            if(viewModel != null){
                              TheMatch? match = viewModel.getCurrentMatch();
                              if(match != null){
                                match.currentBatters[match.currentBatterIndex].outBy = 'Retired Out';
                                match.currentBatters.removeAt(match.currentBatterIndex);
                                print(match.currentBatters);
                                match.addBatter(Batter(battercntrl.text));
                                match.currentBatters = List.of(match.currentBatters.reversed);
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            "Let's Play!!",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0x42A4E190))),
                        ),
                      ),
                    ),
                  ],
                )

            )
        )),);
  }
}
