import 'package:cric_scorer/models/Batter.dart';
import 'package:flutter/material.dart';

class CardBatter extends StatefulWidget {
  final List<Batter> batters ;
  final Function(Batter)? onTap;
  final bool isOnMatchPage;
  const CardBatter(this.batters,this.isOnMatchPage,this.onTap,{super.key});

  @override
  State<CardBatter> createState() => _CardBatterState();
}

class _CardBatterState extends State<CardBatter> {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.batters.length.toString());
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Flexible(
            child:  widget.batters.isNotEmpty ? Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(widget.batters.length+1, (index) {
                if (index == 0) {
                  return TableRow(
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
                      ]);
                } else{
                  Batter batter=widget.batters[index-1];
                  return TableRow(
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                            child: Text(
                              batter.name+(index == 1 && widget.isOnMatchPage?"*":""),
                              style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 13),
                            ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                            batter.runs.toString(),
                            style: TextStyle(color: Colors.white),
                          ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                            batter.balls.toString(),
                            style: TextStyle(color: Colors.white),
                          ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                            batter.fours.toString(),
                            style: TextStyle(color: Colors.white),
                          ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                            batter.sixes.toString(),
                            style: TextStyle(color: Colors.white),
                          ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Text(
                            batter.strikeRate.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white),
                          ),),
                          onTap: (){
                            if (widget.onTap != null){
                              widget.onTap!(batter);
                            }
                          },
                        ),
                      ]);
                }
              },


              ),
            ) : SizedBox(width: 0,height: 0,),
          ),
        ));
  }
}
