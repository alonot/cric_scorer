

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardMatchSettings extends StatefulWidget {
  final _CardMatchSettingsState _state = _CardMatchSettingsState();
  final String team1,team2;
  final String? errorTextOver;
  final String? errorTextPlayer;
  final TextEditingController oversController;
  final TextEditingController noplayersController;

  CardMatchSettings(this.team1,this.team2,this.errorTextOver,this.errorTextPlayer,this.oversController,this.noplayersController,{super.key});

  @override
  State<CardMatchSettings> createState() => _state;

  Map<String, String> getInfo() => _state.getRequiredInfo();
}

class _CardMatchSettingsState extends State<CardMatchSettings> {
  List<String> teems = List<String>.of(["Team 1", "team 2"]);
  String tossWonBy = "Team 1";
  String chooseto = "Bat";




  Map<String, String> getRequiredInfo() => Map.of({
        "toss": tossWonBy,
        "optTo": chooseto,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Card(
        elevation: 20,
        color: Colors.transparent,
        child: Padding(
          padding:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 2.5, right: 2.5, top: 5, bottom: 5),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                            "Toss Won by",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text(
                                    widget.team1,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  leading: Radio<String>(
                                    value: teems[0],
                                    groupValue: tossWonBy,
                                    onChanged: (String? value) {
                                      setState(() {
                                        tossWonBy = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text(
                                    widget.team2,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Radio<String>(
                                    value: teems[1],
                                    groupValue: tossWonBy,
                                    onChanged: (String? value) {
                                      setState(() {
                                        tossWonBy = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 2.5, right: 2.5, top: 5, bottom: 5),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                            "Choose to",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text(
                                    "Bat",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  leading: Radio<String>(
                                    value: "Bat",
                                    groupValue: chooseto,
                                    onChanged: (String? value) {
                                      setState(() {
                                        chooseto = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text(
                                    "Ball",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Radio<String>(
                                    value: "Ball",
                                    groupValue: chooseto,
                                    onChanged: (String? value) {
                                      setState(() {
                                        chooseto = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          if(widget.errorTextOver!=null)
                            widget.errorTextOver!= null;
                          if(widget.errorTextPlayer!=null)
                            widget.errorTextPlayer!= null;
                        });
                      },
                      onChanged: (val){
                        print(widget.oversController.text+val);
                        print(widget.key);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: widget.oversController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          labelText: "Overs",
                          labelStyle: TextStyle(color: Colors.white),
                          errorText: widget.errorTextOver),
                    )),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          if(widget.errorTextOver!=null)
                            widget.errorTextOver!= null;
                          if(widget.errorTextPlayer!=null)
                            widget.errorTextPlayer!= null;
                        });
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: widget.noplayersController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          labelText: "No Of Playes",
                          labelStyle: TextStyle(color: Colors.white),
                          errorText: widget.errorTextPlayer),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
