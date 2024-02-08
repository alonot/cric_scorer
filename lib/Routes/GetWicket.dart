import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class GetWicket extends StatefulWidget {
  const GetWicket({super.key});

  @override
  State<GetWicket> createState() => _GetWicketState();
}

class _GetWicketState extends State<GetWicket> {
  TextEditingController battercntrl = TextEditingController();
  TextEditingController helpercntrl = TextEditingController();
  List<String> batters = [];
  late TheMatch? match;
  String wicketType = 'Bowled';
  String batterOut = '';
  bool showhelper = false;

  @override
  Widget build(BuildContext context) {
    var viewModel = Util.viewModel;
    if (viewModel != null) {
      match = viewModel.getCurrentMatch();
      if (match != null) {
        batters = [
          match!.currentBatters[0].name,
          match!.currentBatters[1].name
        ];
        batterOut = batters[0];
      }
    }

    return Scaffold(
      key: Key("Get Wicket Scaffold"),
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: BoxDecoration(
            border: null,
            image: DecorationImage(
                image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: showhelper ? 500 : 440,
                      child: Column(children: [
                        Card(
                          elevation: 20,
                          color: Colors.transparent,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      ListTile(
                                        title: Text(
                                          'Bowled',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "Bowled",
                                          onChanged: (val) {
                                            setState(() {
                                              wicketType = val!;
                                              showhelper = false;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Hit Wicket',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "Hit wicket",
                                          onChanged: (val) {
                                            setState(() {
                                              wicketType = val!;
                                              showhelper = false;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text(
                                          'Run out',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "Run out",
                                          onChanged: (val) {
                                            setState(() {
                                              wicketType = val!;
                                              showhelper = true;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Catch Out',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "Catch out",
                                          onChanged: (val) {
                                            setState(() {
                                              showhelper = true;
                                              wicketType = val!;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text(
                                          'LBW',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "LBW",
                                          onChanged: (val) {
                                            setState(() {
                                              showhelper = false;
                                              wicketType = val!;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Stumping',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: Radio<String>(
                                          groupValue: wicketType,
                                          value: "Stumping",
                                          onChanged: (val) {
                                            setState(() {
                                              wicketType = val!;
                                              showhelper = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Text(
                                  'Who Got Out?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: ListTile(
                                          title: Text(
                                            batters[0],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          leading: Radio<String>(
                                            groupValue: batterOut,
                                            value: batters[0],
                                            onChanged: (val) {
                                              setState(() {
                                                if (val != null) {
                                                  batterOut = batters[0];
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: ListTile(
                                          title: Text(
                                            batters[1],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          leading: Radio<String>(
                                            groupValue: batterOut,
                                            value: batters[1],
                                            onChanged: (val) {
                                              setState(() {
                                                if (val != null) {
                                                  batterOut = batters[1];
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                                showhelper
                                    ? TextField(
                                  controller: helpercntrl,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                      labelText: 'Who Helped',
                                      labelStyle:
                                      TextStyle(color: Colors.white)),
                                )
                                    : SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                                TextField(
                                  controller: battercntrl,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                      labelText: 'Next Batter',
                                      labelStyle: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint("Lets Continue > Got Wicket!!");
                                if (battercntrl.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      Util.getsnackbar('Fields must not be empty'));
                                  return;
                                }
                                if (showhelper) {
                                  print("Yes"+helpercntrl.text);
                                  if (helpercntrl.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        Util.getsnackbar('Fields must not be empty'));
                                    return;
                                  }
                                }
                                if (match != null) {
                                  Batter? batter;
                                  for (Batter b in match!.currentBatters) {
                                    if (b.name == batterOut) {
                                      batter = b;
                                      break;
                                    }
                                  }
                                  switch (wicketType) {
                                    case "Hit Wicket":
                                      batter!.outBy = 'Hit Wicket';
                                      break;
                                    case "LBW":
                                      batter!.outBy = 'LBW ';
                                      break;
                                    case "Stumping":
                                      batter!.outBy = 'St ${helpercntrl.text} ';
                                      break;
                                    case "Catch Out":
                                      batter!.outBy = 'c ${helpercntrl.text}';
                                      break;
                                    case 'Run out':
                                      batter!.outBy = 'run out (${helpercntrl.text})';
                                      break;
                                  }
                                  if (wicketType != "Run Out") {
                                    batter!.outBy += 'b ${match!.currentBowler}';
                                  }
                                  match!.wicketOrder.add(batter!);
                                  match!.currentBatters.remove(batter);
                                  batter = Batter(battercntrl.text);
                                  match!.addBatter(batter);

                                  Navigator.pop(context);
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
                  )),
            ),
          )),
    );
  }
}
