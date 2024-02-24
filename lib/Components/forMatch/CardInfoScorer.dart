import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class CardInfoScorer extends StatefulWidget {
  const CardInfoScorer({super.key});

  @override
  State<CardInfoScorer> createState() => _CardInfoScorerState();
}

class _CardInfoScorerState extends State<CardInfoScorer> {
  final MatchViewModel viewModel = MatchViewModel();
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

  @override
  Widget build(BuildContext context) {
    setState(() {
      var randomError = "";
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
            match.currentTeam == 0 ? Colors.white : const Color(0xff9b9b9b);
        _team2Color =
            match.currentTeam == 1 ? Colors.white : const Color(0xff9b9b9b);
        _is2ndinning = match.inning == 2;
        loading = false;

        if (_is2ndinning) {
          int cur = match.currentTeam;
          _needrun =
              (match.score[(cur + 1) % 2] - match.score[cur] + 1).toString();
          int curBalls = ((match.over_count[cur] * 10).toInt() ~/ 10 * 6) +
              ((match.over_count[cur] * 10).toInt() % 10).toInt();
          int totalBalls = ((match.totalOvers * 10).toInt() ~/ 10 * 6);
          _needfrom = (totalBalls - curBalls).toString();
        }
      }
      if (randomError.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.grey,
          content: Text(randomError),
        ));
      }
    });

    return !loading
        ? GestureDetector(
            child: Card(
                elevation: 20,
                color: Colors.transparent,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
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
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.only(right: 0),
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
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          _team1,
                                          style: TextStyle(
                                              color: _team1Color, fontSize: 12),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          _score1,
                                          style: TextStyle(
                                              color: _team1Color,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          '$_overs1 OVERS',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            _team2,
                                            style: TextStyle(
                                                color: _team2Color,
                                                fontSize: 12),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(_score2,
                                              style: TextStyle(
                                                  color: _team2Color,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text('$_overs2 OVERS',
                                              style: TextStyle(
                                                  color: _team2Color,
                                                  fontSize: 12),
                                              textAlign: TextAlign.end),
                                        ),
                                      ],
                                    ),
                                  ), // Team 2 Score
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding:
                                            const EdgeInsets.only(right: 0),
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
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Need '),
                                        TextSpan(
                                            text: '$_needrun runs ',
                                            style: const TextStyle(
                                                color: Colors.red)),
                                        const TextSpan(text: 'from '),
                                        TextSpan(
                                            text: '$_needfrom balls',
                                            style: const TextStyle(
                                                color: Colors.red)),
                                      ]),
                                ),
                              ))
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  )),
                )),
            onTap: () {
              Navigator.pushNamed(context, Util.scoreCardRoute);
            },
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }
}
