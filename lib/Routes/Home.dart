import 'package:cric_scorer/Components/forHome/CardInfo.dart';
import 'package:cric_scorer/Components/forHome/CardMatchSettings.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CardMatchSettings matchsetting;
  late CardInfo infoCard;
  String _team1="Team 1",_team2="Team 2";
  String? errorTextOver;
  String? errorTextPlayer;
  final TextEditingController oversController=TextEditingController();
  final TextEditingController noplayersController=TextEditingController();

  void update(String t1,String t2){
    debugPrint(t1+t2);
    setState(() {
      _team1=t1;
      _team2=t2;
    });
  }

  bool validate() {
    var allGood = true;
    if (oversController.text.isEmpty) {
      print("yes");
      allGood = false;
      setState(() {
        errorTextOver = 'Required';
      });
    } else {
      print("No");
      if (int.parse(oversController.text) > 450) {
        allGood = false;
        setState(() {
          errorTextOver = "too big";
          oversController.text = "";
        });
      } else {
        setState(() {
          errorTextOver = null;
        });
      }
    }

    if (noplayersController.text.isEmpty) {
      allGood = false;
      setState(() {
        errorTextPlayer = 'Required';
      });
    } else {
      if (int.parse(noplayersController.text) > 25) {
        allGood = false;
        setState(() {
          errorTextPlayer = "too big";
          noplayersController.text = "";
        });
      } else {
        setState(() {
          errorTextPlayer = null;
        });
      }
    }
    if(_team1 == _team2 ){
          allGood=false;
          ScaffoldMessenger.of(context).showSnackBar(Util.getsnackbar("Both names cannot be same!!!"));
        }
        if(_team1.isEmpty || _team2.isEmpty ){
          allGood=false;
          ScaffoldMessenger.of(context).showSnackBar(Util.getsnackbar("Team name cannot be Empty!!!"));
        }
    return allGood;
  }


  @override
  Widget build(BuildContext context) {
    infoCard = CardInfo(update);
    matchsetting= CardMatchSettings(_team1,_team2,errorTextOver,errorTextPlayer,oversController,noplayersController,key: Key("supreb"),);
    return Container(
        decoration: BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Color(0x89000000),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    height: 180,
                    child: infoCard,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    height: 280,
                    child: matchsetting,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint("Lets Play!!");
                          var randomError="";
                          if (Util.viewModel != null){
                            bool result =validate();
                            if(result) {
                              Map<String,String> info1=infoCard.getInfo();
                              Map<String,String> info2= matchsetting.getInfo();
                              var result =Util.viewModel!.setCurrentMatch(TheMatch(info1['team1']!,
                                  info1['team1Url']!,
                                  info1['team2']!,
                                  info1['team2Url']!,
                                  info2['toss']!,
                                  info2['optTo']!,
                                  int.parse(noplayersController.text),
                                  int.parse(oversController.text),
                              )
                              );
                              Navigator.pushNamed(context, "Get Openers");
                            }
                          }else{
                            randomError="View Model Not Found. I need A restart~~";
                          }
                          if(randomError.isNotEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(Util.getsnackbar(randomError));
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
              ),
            ),
          ),
        ));
  }
}
