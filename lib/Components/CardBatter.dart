import 'package:flutter/material.dart';

class CardBatter extends StatefulWidget {
  const CardBatter({super.key});

  @override
  State<CardBatter> createState() => _CardBatterState();
}

class _CardBatterState extends State<CardBatter> {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                  decoration: BoxDecoration(
                    border: _border,
                  ),
                  children: const <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                    child: Text(
                      'BATSMAN',
                      style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 13),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                      'R',
                      style: TextStyle(color: Colors.white),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                      'B',
                      style: TextStyle(color: Colors.white),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                      '4s',
                      style: TextStyle(color: Colors.white),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                      '6s',
                      style: TextStyle(color: Colors.white),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                      'RN',
                      style: TextStyle(color: Colors.white),
                    ),),
                  ]),
              const TableRow(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                    child: Text(
                      'BATSMAN',
                      style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 13),
                    ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'R',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'B',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    '4s',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    '6s',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'RN',
                    style: TextStyle(color: Colors.white),
                  ),),
                ]
              ),
              const TableRow(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                    child: Text(
                      'BATSMAN',
                      style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 13),
                    ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'R',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'B',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    '4s',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    '6s',
                    style: TextStyle(color: Colors.white),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                    'RN',
                    style: TextStyle(color: Colors.white),
                  ),),
                ]
              ),
            ],
          ),
        ));
  }
}
