import 'package:flutter/material.dart';

class CardScorer extends StatefulWidget {
  const CardScorer({super.key});

  @override
  State<CardScorer> createState() => _CardScorerState();
}

class _CardScorerState extends State<CardScorer> {

  bool wideBall=false;
  bool noBall=false;
  bool legbyes=false;
  bool byes=false;
  bool wicket=false;

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
                      0:FlexColumnWidth(4),
                      1:FlexColumnWidth(4),
                      2:FlexColumnWidth(3),
                      3:FlexColumnWidth(4),
                      4:FlexColumnWidth(4),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                          children: <Widget>[
                            Center(
                                child: Row(
                                  children: [
                                    Checkbox(value: wideBall, onChanged: (bool? val){

                                      setState(() {
                                        wideBall=val!;
                                      });
                                    },),
                                    Text('Wide',style: TextStyle(color: Colors.white),)
                                  ],
                                )
                            ),
                            Center(
                                child: Row(
                                  children: [
                                    Checkbox(value: legbyes, onChanged: (bool? val){

                                      setState(() {
                                        legbyes=val!;
                                      });
                                    },),
                                    Text('Leg \nByes',style: TextStyle(color: Colors.white),)
                                  ],
                                )
                            ),
                            Center(
                                child: Row(
                                  children: [
                                    Checkbox(value: wicket, onChanged: (bool? val){

                                      setState(() {
                                        wicket=val!;
                                      });
                                    },),
                                    Transform.scale(
                                      scaleY: 4,
                                      scaleX: 2,
                                      child: SizedBox(
                                        width: 10,height: 40,
                                        child: Tab(icon: Image.asset('assests/wicket.jpg')),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            Center(
                                child: Row(
                                  children: [
                                    Checkbox(value: byes, onChanged: (bool? val){

                                      setState(() {
                                        byes=val!;
                                      });
                                    },),
                                    Text('Byes',style: TextStyle(color: Colors.white),)
                                  ],
                                )
                            ),
                            Center(
                                child: Row(
                                  children: [
                                    Checkbox(value: noBall, onChanged: (bool? val){

                                      setState(() {
                                        noBall=val!;
                                      });
                                    },),
                                    Padding(padding: EdgeInsets.all(0),child: Text('No\nball',style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),)
                                  ],
                                )
                            ),
                          ]
                      ),
                    ],
                  ),
                )),
          )
        ),
        Container(
          height: 130,
          child: Card(
              elevation: 20,
              color: Colors.transparent,
              child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                    children: [
                      Expanded(flex: 3,child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                              children: <Widget>[
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '0',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '2',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '3',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                )
                              ]
                          ),
                          TableRow(
                              children: <Widget>[
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '4',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '5',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '6',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                ),
                                Center(
                                    child:Transform.scale(
                                      scale: 0.85,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1.5,
                                                color: Color(0xff01579B)
                                            ),
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(45),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            fixedSize: Size(60, 60)
                                        ),
                                        child: Text(
                                          '...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                    )
                                )
                              ]
                          )
                        ],
                      ),),
                      Expanded(flex: 1,child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: <Expanded>[
                            Expanded(child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
                              child: ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                child: Text('UNDO',style: TextStyle(color: Colors.white),),
                              ),
                            )),
                            Expanded(child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
                              child: ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                child: Text('RETIRE',style: TextStyle(color: Colors.white),),
                              ),
                            )),
                            Expanded(child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
                              child: ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                child: Text('SWAP',style: TextStyle(color: Colors.white),),
                              ),
                            )),
                          ],
                        ),
                      ),),
                    ],
                  )
              )),

        )
      ],
    );
  }
}
