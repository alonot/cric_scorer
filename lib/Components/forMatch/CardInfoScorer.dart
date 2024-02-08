import 'package:cric_scorer/models/Match.dart';
import 'package:flutter/material.dart';

import '/utils/util.dart';

class CardInfoScorer extends StatefulWidget {
  final viewModel = Util.viewModel;


  @override
  State<CardInfoScorer> createState() => _CardInfoScorerState(viewModel);
}

class _CardInfoScorerState extends State<CardInfoScorer> {
  var viewModel;
  String _team1Url = "assests/csk.jpg";
  String _team2Url = "assests/rcb.jpg";
  String _team1 = "Team 1";
  String _team2 = "Team 2";
  String _score1 = "0-0";
  String _score2 = "0-0";
  String _overs1 = "0.0";
  String _overs2 = "0.0";
  String _needrun = "0";
  String _needfrom = "0";
  Color _team1Color = Colors.white;
  Color _team2Color = Colors.white;
  bool _is2ndinning = false;
  bool loading = false;

  _CardInfoScorerState(this.viewModel);

  @override
  Widget build(BuildContext context) {
    setState(() {
      var randomError = "";
      if (viewModel != null) {
        TheMatch? match = viewModel.getCurrentMatch();
        if (match == null) {
          Navigator.pop(context);
        } else {
          debugPrint(match.currentTeam.toString());
          loading = true;
          _team2Url = match.team2url;
          _team1Url = match.team1url;
          _team1 = match.team1;
          _team2 = match.team2;
          _score1 = "${match.score[0]}-${match.wickets[0]}";
          _score2 = "${match.score[1]}-${match.wickets[1]}";
          _overs1 = match.over_count[0].toStringAsFixed(1);
          _overs2 = match.over_count[1].toStringAsFixed(1);
          _team1Color =
              match.currentTeam == 0 ? Colors.white : Color(0xff9b9b9b);
          _team2Color =
              match.currentTeam == 1 ? Colors.white : Color(0xff9b9b9b);
          _is2ndinning = match.inning == 2;
          loading = false;
        }
      } else {
        randomError = "View Model Not Found. I need A restart~~";
      }
      if (randomError.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.grey,
          content: Text(randomError),
        ));
      }
    });

    return !loading
        ? Card(
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
                                      image: AssetImage(_team1Url),
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
                                    _team1,
                                    style: TextStyle(
                                        color:_team1Color, fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  width: double.infinity,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    _score1,
                                    style: TextStyle(
                                        color:_team1Color,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    _overs1 + ' OVERS',
                                    style: TextStyle(
                                        color: _team1Color, fontSize: 12),
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
                                      _team2,
                                      style: TextStyle(
                                          color:_team2Color,
                                          fontSize: 12),
                                      textAlign: TextAlign.end,
                                    ),
                                    width: double.infinity,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(_score2,
                                        style: TextStyle(
                                            color:_team2Color,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(_overs2 + ' OVERS',
                                        style: TextStyle(
                                            color: _team2Color, fontSize: 12),
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
                                        image: AssetImage(_team2Url),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ), // Team 2 Avatar
                          ],
                        )),
                      ],
                    )),
                _is2ndinning
                    ? Flexible(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(text: 'Need '),
                                  TextSpan(
                                      text: _needrun + ' runs ',
                                      style: TextStyle(color: Colors.red)),
                                  TextSpan(text: 'from '),
                                  TextSpan(
                                      text: _needfrom + ' balls',
                                      style: TextStyle(color: Colors.red)),
                                ]),
                          ),
                        ))
                    : new SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            )))
        : SizedBox(
            width: 0,
            height: 0,
          );
  }
}
