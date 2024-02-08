import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:cric_scorer/models/Over.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/util.dart';

class GetOpeners extends StatefulWidget {
  const GetOpeners({super.key});

  @override
  State<GetOpeners> createState() => _GetOpenersState();
}

class _GetOpenersState extends State<GetOpeners> {
  TextEditingController batter1cntrl = TextEditingController();
  TextEditingController batter2cntrl = TextEditingController();
  TextEditingController bowlercntrl = TextEditingController();
  String? errorBatter1=null;
  String? errorBatter2=null;
  String? errorBowler=null;

  bool _validate(){
    bool allGood = true;
    if(batter1cntrl.text.isEmpty){
      allGood=false;
      setState(() {
        errorBatter1="required";
      });
    }else{
      setState(() {
        errorBatter1=null;
      });
    }

    if(batter2cntrl.text.isEmpty){
      allGood=false;
      setState(() {
        errorBatter2="required";
      });
    }else{
      setState(() {
        errorBatter2=null;
      });
    }

    if(bowlercntrl.text.isEmpty){
      allGood=false;
      setState(() {
        errorBowler="required";
      });
    }else{
      setState(() {
        errorBowler=null;
      });
    }
    return allGood;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(children: [
                Card(
                  elevation: 20,
                  color: Colors.transparent,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextField(
                            controller: batter1cntrl,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                labelText: 'Batter 1',
                                errorText: errorBatter1,
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                          TextField(
                            controller: batter2cntrl,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                labelText: 'Batter 2',
                                errorText: errorBatter2,
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                          TextField(
                            controller: bowlercntrl,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            decoration: InputDecoration(
                                labelText: 'Bowler',
                                errorText: errorBowler,
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Lets Play!2!");
                        var randomError="";
                        if (Util.viewModel != null){
                          bool result =_validate();
                          print(result);
                          if(result) {
                            var match = Util.viewModel?.getCurrentMatch();
                            if(match == null){
                              Navigator.pop(context);
                            }
                            Bowler bowler= Bowler(bowlercntrl.text);
                            Batter batter1 =  Batter(batter1cntrl.text);
                            Batter batter2 =  Batter(batter2cntrl.text);
                            match!.addBowler(bowler);
                            match.addBatter(batter1);
                            match.addBatter(batter2);
                            match.Overs[match.currentTeam].add(Over(0,bowler.name,[batter1.name]));
                            match.currentBatterIndex = 0;
                            print(match.team1);
                            Navigator.pushNamedAndRemoveUntil(context, "Match Page",(route)=> false);
                          }
                        }else{
                          randomError="View Model Not Found. I need A restart~~";
                        }
                        if(randomError.isNotEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.grey,content: Text(randomError),));
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
              ]),
            ),
          ),
        ));
  }
}
