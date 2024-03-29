import 'package:flutter/material.dart';

class CardScorer extends StatefulWidget {
  final void Function(String, String) update;
  final void Function() popIt;
  final void Function() swap;
  final void Function() retire;
  final void Function() endInning;

  const CardScorer(
      this.update, this.popIt, this.swap, this.retire, this.endInning,
      {super.key});

  @override
  State<CardScorer> createState() => _CardScorerState();
}

class _CardScorerState extends State<CardScorer> {
  String type = "";
  bool wicket = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 70,
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Card(
                  elevation: 20,
                  color: Colors.transparent,
                  child: Padding(
                    // ignore: prefer_const_constructors
                    padding: EdgeInsets.all(0.0),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(3),
                        3: FlexColumnWidth(4),
                        4: FlexColumnWidth(4),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          Center(
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Radio<String>(
                                    value: "Wd",
                                    groupValue: type,
                                    onChanged: (val) {
                                      setState(() {
                                        type = "Wd";
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onDoubleTap: (){
                                    setState(() {
                                      type = "";
                                    });
                                  },
                                  child: const Text(
                                    'Wide',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Radio<String>(
                                      groupValue: type,
                                      value: "LB",
                                      onChanged: (val) {
                                        setState(() {
                                          type = "LB";
                                        });
                                      },
                                    )),
                                 Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    child: Text(
                                      'Leg Bye',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onDoubleTap: (){
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Checkbox(
                                  value: wicket,
                                  onChanged: (bool? val) {
                                    setState(() {
                                      wicket = val!;
                                    });
                                  },
                                ),
                              ),
                              Transform.scale(
                                  scaleY: 4,
                                  scaleX: 2,
                                  child: Center(
                                    child: SizedBox(
                                      width: 10,
                                      height: 40,
                                      child: Center(
                                        child: Tab(
                                            icon: Image.asset(
                                                'assests/wicket.jpg')),
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Radio<String>(
                                  value: "B",
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = "B";
                                    });
                                  },
                                ),
                              ),
                               Flexible(
                                fit: FlexFit.loose,
                                child: GestureDetector(
                                  onDoubleTap: (){
                                    setState(() {
                                      type = "";
                                    });
                                  },
                                  child: const Text(
                                    'Bye',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              )
                            ],
                          )),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Radio<String>(
                                  value: "Nb",
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = "Nb";
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: GestureDetector(
                                  onDoubleTap: (){
                                    setState(() {
                                      type = "";
                                    });
                                  },
                                  child: Text(
                                    'No ball',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                            ],
                          )),
                        ]),
                      ],
                    ),
                  )),
            )),
        SizedBox(
          height: 130,
          child: Card(
              elevation: 20,
              color: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 3,
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(
                                          type, "0${wicket ? "OUT" : ""}");
                                      setState(() {
                                        type = "";
                                        wicket = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: const EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(60, 60)),
                                    child: const Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(
                                          type, "1${wicket ? "OUT" : ""}");
                                      setState(() {
                                        type = "";
                                        wicket = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: const EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(60, 60)),
                                    child: const Text(
                                      '1',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(
                                          type, "2${wicket ? "OUT" : ""}");
                                      setState(() {
                                        type = "";
                                        wicket = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: const EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(60, 60)),
                                    child: const Text(
                                      '2',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(
                                          type, "3${wicket ? "OUT" : ""}");
                                      setState(() {
                                        type = "";
                                        wicket = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: const EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(60, 60)),
                                    child: const Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ))
                              ]),
                              TableRow(children: <Widget>[
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(
                                          type, "4${wicket ? "OUT" : ""}");
                                      setState(() {
                                        type = "";
                                        wicket = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: const EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(60, 60)),
                                    child: const Text(
                                      '4',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )),
                                Center(
                                  child: Transform.scale(
                                    scale: 0.85,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.update(
                                            type, "5${wicket ? "OUT" : ""}");
                                        setState(() {
                                          type = "";
                                          wicket = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: const EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: const Size(60, 60)),
                                      child: const Text(
                                        '5',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Transform.scale(
                                    scale: 0.85,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.update(
                                            type, "6${wicket ? "OUT" : ""}");
                                        setState(() {
                                          type = "";
                                          wicket = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: const EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: const Size(60, 60)),
                                      child: const Text(
                                        '6',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Transform.scale(
                                    scale: 0.85,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.endInning();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: const EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: const Size(60, 60)),
                                      child: const Text(
                                        '...',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ])
                            ],
                          )),
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 2.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          widget.popIt();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            )),
                                        child: const Text('UNDO',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 2.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.retire();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                      child: const Text(
                                        'RETIRE',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 2.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.swap();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                      child: const Text(
                                        'SWAP',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ))),
        )
      ],
    );
  }
}
