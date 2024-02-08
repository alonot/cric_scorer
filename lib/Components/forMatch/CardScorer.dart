import 'package:flutter/material.dart';

class CardScorer extends StatefulWidget {
  void Function(String,String) update;
  void Function() popIt;
  CardScorer(this.update,this.popIt, {super.key});

  @override
  State<CardScorer> createState() => _CardScorerState();
}

class _CardScorerState extends State<CardScorer> {
  String type="";
  bool wicket =false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 70,
            padding: EdgeInsets.all(0),
            child: Center(
              child: Card(
                  elevation: 20,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Table(
                      columnWidths: {
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
                                  child: Radio<String>(
                                    value: "Wd",
                                    groupValue: type,
                                    onChanged: (val) {
                                      setState(() {
                                        type="Wd";
                                      });
                                    },
                                  ),
                                  fit: FlexFit.loose,
                                ),
                                Text(
                                  'Wide',
                                  style: TextStyle(color: Colors.white),textAlign: TextAlign.center,
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
                                          type="LB";
                                        });
                                      },
                                    )),
                                Flexible(
                                  child: Text(
                                    'Leg Bye',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  fit: FlexFit.loose,
                                )
                              ],
                            ),
                          ),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                child: Checkbox(
                                  value: wicket,
                                  onChanged: (bool? val) {
                                    setState(() {
                                      wicket = val!;
                                    });
                                  },
                                ),
                                fit: FlexFit.loose,
                              ),
                              Transform.scale(
                                scaleY: 4,
                                scaleX: 2,
                                child: Center(child: SizedBox(
                                  width: 10,
                                  height: 40,
                                  child: Center(child: Tab(
                                      icon: Image.asset('assests/wicket.jpg')),),
                                ),)
                              )
                            ],
                          )),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                child: Radio<String>(
                                  value: "B",
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = "B";
                                    });
                                  },
                                ),
                                fit: FlexFit.loose,
                              ),
                              Flexible(
                                child: Text(
                                  'Bye',
                                  style: TextStyle(color: Colors.white),
                                ),
                                fit: FlexFit.loose,
                              )
                            ],
                          )),
                          Center(
                              child: Row(
                            children: [
                              Flexible(
                                child: Radio<String>(
                                  value: "Nb",
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = "Nb";
                                    });
                                  },
                                ),
                                fit: FlexFit.loose,
                              ),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  'No ball',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                          )),
                        ]),
                      ],
                    ),
                  )),
            )),
        Container(
          height: 130,
          child: Card(
              elevation: 20,
              color: Colors.transparent,
              child: Padding(
                  padding: EdgeInsets.all(0.0),
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
                              TableRow(
                                  children: <Widget>[
                                Center(
                                    child: Transform.scale(
                                  scale: 0.85,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.update(type,"0");
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: Size(60, 60)),
                                    child: Text(
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
                                      widget.update(type,"1");
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: Size(60, 60)),
                                    child: Text(
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
                                      widget.update(type,"2");
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: Size(60, 60)),
                                    child: Text(
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
                                      widget.update(type,"3");
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: Size(60, 60)),
                                    child: Text(
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
                                      widget.update(type,"4");
                                      setState(() {
                                        type = "";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Color(0xff01579B)),
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        fixedSize: Size(60, 60)),
                                    child: Text(
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
                                        widget.update(type,"5");
                                        setState(() {
                                          type = "";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: Size(60, 60)),
                                      child: Text(
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
                                        widget.update(type,"6");
                                        setState(() {
                                          type = "";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: Size(60, 60)),
                                      child: Text(
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
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: Color(0xff01579B)),
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          fixedSize: Size(60, 60)),
                                      child: Text(
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
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
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
                                        child: Text('UNDO',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 2.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                      child: Text(
                                        'RETIRE',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 2.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                      child: Text(
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
