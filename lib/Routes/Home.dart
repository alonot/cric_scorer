import 'package:cric_scorer/Components/forHome/CardInfo.dart';
import 'package:cric_scorer/Components/forHome/CardMatchSettings.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MatchViewModel viewModel = MatchViewModel();
  late CardMatchSettings matchsetting;
  late CardInfo infoCard;
  String _team1 = "Team 1", _team2 = "Team 2";
  String? errorTextOver;
  String? errorTextPlayer;
  final TextEditingController oversController = TextEditingController();
  final TextEditingController noplayersController = TextEditingController();

  void update(String t1, String t2) {
    debugPrint(t1 + t2);
    setState(() {
      _team1 = t1;
      _team2 = t2;
    });
  }

  void resetError() {
    setState(() {
      errorTextPlayer = null;
      errorTextOver = null;
    });
  }

  bool validate() {
    var allGood = true;
    if (oversController.text.isEmpty) {
      // print("yes");
      allGood = false;
      setState(() {
        errorTextOver = 'Required';
      });
    } else {
      // print("No ${oversController.text}");
      if (int.parse(oversController.text) > 450 ||
          int.parse(oversController.text) < 1) {
        allGood = false;
        setState(() {
          errorTextOver = "Range : 1 - 450";
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
      if (int.parse(noplayersController.text) > 25 ||
          int.parse(noplayersController.text) < 3) {
        allGood = false;
        setState(() {
          errorTextPlayer = "Range : 3 - 25";
          noplayersController.text = "";
        });
      } else {
        setState(() {
          errorTextPlayer = null;
        });
      }
    }
    if (_team1 == _team2) {
      allGood = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar("Both names cannot be same!!!"));
    }
    if (_team1.isEmpty || _team2.isEmpty) {
      allGood = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar("Team name cannot be Empty!!!"));
    }
    return allGood;
  }

  @override
  Widget build(BuildContext context) {
    infoCard = CardInfo(update);
    matchsetting = CardMatchSettings(
      _team1,
      _team2,
      errorTextOver,
      errorTextPlayer,
      oversController,
      noplayersController,
      resetError,
      key: const Key("supreb"),
    );
    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x89000000),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 15),
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
                    height: 350,
                    child: matchsetting,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint("Lets Play!!");
                          var randomError = "";
                            bool result = validate();
                            if (result) {
                              Map<String, String> info1 = infoCard.getInfo();
                              Map<String, String> info2 =
                                  matchsetting.getInfo();
                              TheMatch match = TheMatch(
                                info1['team1']!,
                                info1['team1Url']!,
                                info1['team2']!,
                                info1['team2Url']!,
                                info2['toss']!,
                                info2['optTo']!,
                                int.parse(noplayersController.text),
                                int.parse(oversController.text),
                              );
                              viewModel.setCurrentMatch(match);
                              _save(match);
                              Navigator.pushNamed(context, "Get Openers");
                            }
                          if (randomError.isNotEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(Util.getsnackbar(randomError));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(const Color(0x42A4E190))),
                        child: const Text(
                          "Let's Play!!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _save(TheMatch match) async {
    int result;
    result = await viewModel.insertMatch(match);
    if(result != -1){
      // debugPrint("result${result}");
      match.id = result;
    }
    // print(result.toString()+"IDDDD");
  }
}
