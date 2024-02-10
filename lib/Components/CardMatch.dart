import 'package:flutter/material.dart';

class CardMatch extends StatefulWidget {
  final String team1Url;
  final String team2Url;
  final String team1;
  final String team2;
  final String score1;
  final String score2;
  final String overs1;
  final String overs2;
  final String needrun;
  final String needfrom;
  final bool wicket;
  final Color team1Color;
  final Color team2Color;
  final bool is2ndinning;
  final bool hasWon;
  final String wonBy;
  final Function(bool) onTap;

  const CardMatch(
      this.onTap,
      {
      this.team1Url = "assests/csk.jpg",
      this.team2Url = "assests/rcb.jpg",
      this.team1 = "Team 1",
      this.team2 = "Team 2",
      this.score1 = "0-0",
      this.score2 = "0-0",
      this.overs1 = "0.0",
      this.overs2 = "0.0",
      this.needrun = "0",
      this.needfrom = "0",
      this.wicket =false,
      this.team1Color = Colors.white,
      this.team2Color = Colors.white,
      this.is2ndinning = false,
      this.wonBy = "",
      this.hasWon = false,super.key});

  @override
  State<CardMatch> createState() => CardMatchState();
}

class CardMatchState extends State<CardMatch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          elevation: 20,
          color: Colors.transparent,
          child: Center(
              child: Column(
                children: [
                  Flexible(
                      flex: 8,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.only(right: 0),
                                        ),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(widget.team1Url),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      )), // Team 1 Avatar
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              widget.team1,
                                              style: TextStyle(
                                                  color:widget.team1Color, fontSize: 12),
                                              textAlign: TextAlign.start,
                                            ),
                                            width: double.infinity,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              widget.score1,
                                              style: TextStyle(
                                                  color:widget.team1Color,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              widget.overs1 + ' OVERS',
                                              style: TextStyle(
                                                  color: widget.team1Color, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      )), // Team 1 score
                                ],
                              )),
                          Flexible(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.team2,
                                            style: TextStyle(
                                                color:widget.team2Color,
                                                fontSize: 12),
                                            textAlign: TextAlign.end,
                                          ),
                                          width: double.infinity,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(widget.score2,
                                              style: TextStyle(
                                                  color:widget.team2Color,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(widget.overs2 + ' OVERS',
                                              style: TextStyle(
                                                  color: widget.team2Color, fontSize: 12),
                                              textAlign: TextAlign.end),
                                        ),
                                      ],
                                    ),
                                  ), // Team 2 Score
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.only(right: 0),
                                      ),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(widget.team2Url),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ), // Team 2 Avatar
                                ],
                              )),
                        ],
                      )),
                  widget.is2ndinning
                      ? Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: widget.hasWon ?
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: 'Won by'),
                                TextSpan(
                                    text: widget.wonBy,
                                    style: TextStyle(color: Colors.red)),
                              ]),
                        )
                            :RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: 'Need '),
                                TextSpan(
                                    text: widget.needrun + ' runs ',
                                    style: TextStyle(color: Colors.red)),
                                TextSpan(text: 'from '),
                                TextSpan(
                                    text: widget.needfrom + ' balls',
                                    style: TextStyle(color: Colors.red)),
                              ]),
                        ),
                      ))
                      : new SizedBox(
                    width: 0,
                    height: 0,
                  ),
                ],
              ))),
      onTap: (){
        widget.onTap(widget.hasWon);
      },
    );
  }
}
