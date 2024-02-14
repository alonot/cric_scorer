import 'package:cric_scorer/models/Bowler.dart';
import 'package:flutter/material.dart';

class CardBowler extends StatefulWidget {
  final List<Bowler> bowlers;
  final Function(Bowler?)? OnTap;

  CardBowler(this.bowlers, {this.OnTap, super.key});

  @override
  State<CardBowler> createState() => _CardBowlerState();
}

class _CardBowlerState extends State<CardBowler> {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: widget.bowlers.isNotEmpty
              ? Table(
                  columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                    },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: List.generate(widget.bowlers.length + 1, (index) {
                    if (index == 0) {
                      return TableRow(
                          decoration: BoxDecoration(
                            border: _border,
                          ),
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                              child: Text(
                                'Bowler',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'O',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'M',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'W',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'R',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'Eco',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ]);
                    } else {
                      Bowler bowler = widget.bowlers[index - 1];
                      return TableRow(children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                            child: Text(
                              bowler.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 13),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              bowler.overs.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              bowler.maidens.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              bowler.wickets.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              bowler.runs.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              bowler.economy.toStringAsFixed(2),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.OnTap != null) {
                              widget.OnTap!(bowler);
                            }
                          },
                        ),
                      ]);
                    }
                  }))
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ));
  }
}
