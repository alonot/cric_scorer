import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

class CardMatch extends StatelessWidget {
  String team1Url = "assests/csk.jpg";
  String team2Url = "assests/rcb.jpg";
  String team1 = "Team 1";
  String team2 = "Team 2";
  String score1 = "0-0";
  String score2 = "0-0";
  String overs1 = "0.0";
  String overs2 = "0.0";
  String needrun = "0";
  String needfrom = "0";
  Color team1Color = Colors.white;
  Color team2Color = Colors.white;
  bool is2ndinning = false;
  bool hasWon = false;
  bool uploaded = false;
  String wonBy = "";
  String teamWon = '';
  int? id;
  final Function(bool, int?) onTap;
  final Function(bool, int?) onTapUpload;

  CardMatch(this.onTap, this.onTapUpload,{TheMatch? match, super.key}) {
    if (match != null) {
      id = match.id;
      team1Url = match.team1url;
      team2Url = match.team2url;
      team1 = match.team1;
      team2 = match.team2;
      score1 = "${match.score[0]}-${match.wickets[0]}";
      score2 = "${match.score[1]}-${match.wickets[1]}";
      overs1 = match.over_count[0].toStringAsFixed(1);
      overs2 = match.over_count[1].toStringAsFixed(1);
      uploaded = match.uploaded;

      needrun = (match.score[(match.currentTeam + 1) % 2] -
          match.score[match.currentTeam])
          .toString();
      int overs = (match.over_count[match.currentTeam] * 10).toInt();
      int overCount =
          (match.totalOvers * 6) - ((overs ~/ 10 * 6).toInt() + overs % 10);
      debugPrint("$overs,${overCount}");
      needfrom = overCount.toString();

      team1Color = match.currentTeam == 0 ? Colors.white : Color(0xff9b9b9b);
      team2Color = match.currentTeam == 1 ? Colors.white : Color(0xff9b9b9b);
      is2ndinning = match.inning == 2;
      hasWon = match.hasWon;
      wonBy = '';
      if (hasWon) {
        int cur = match.currentTeam;
        if (match.score[cur] >= match.score[(cur + 1) % 2]) {
          teamWon = cur == 0 ? match.team1 : match.team2;
          wonBy = "${match.no_of_players - 1 - match.wickets[cur]} wickets";
        } else {
          teamWon = cur == 0 ? match.team2 : match.team1;
          wonBy = "${match.score[(cur + 1) % 2] - match.score[cur] } runs";
        }
      }
    }
  }

  final MatchViewModel viewModel = MatchViewModel();

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: Center(
            child: Column(
              children: [
                !uploaded ? Flexible(
                    flex: 2,
                    child: ListTile(
                        trailing: GestureDetector(
                          child: Icon(Icons.upload,color: Colors.white,),
                          onTap: (){
                            onTapUpload(hasWon,id);
                          },
                        ),
                        visualDensity: VisualDensity(vertical: -4))): SizedBox(width: 0,height: 0,),
                Flexible(
                    flex: 8,
                    child: GestureDetector(
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
                                              image: AssetImage(
                                                  team1Url),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ), // Team 1 Avatar
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            child: Text(
                                              team1,
                                              style: TextStyle(
                                                  color: team1Color,
                                                  fontSize: 12),
                                              textAlign: TextAlign.start,
                                            ),
                                            width: double.infinity,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              score1,
                                              style: TextStyle(
                                                  color: team1Color,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              overs1 + ' OVERS',
                                              style: TextStyle(
                                                  color: team1Color,
                                                  fontSize: 12),
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: [
                                        Container(
                                          child: Text(
                                            team2,
                                            style: TextStyle(
                                                color: team2Color,
                                                fontSize: 12),
                                            textAlign: TextAlign.end,
                                          ),
                                          width: double.infinity,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(score2,
                                              style: TextStyle(
                                                  color: team2Color,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(overs2 + ' OVERS',
                                              style: TextStyle(
                                                  color: team2Color,
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
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.only(right: 0),
                                      ),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  team2Url),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ), // Team 2 Avatar
                                ],
                              )),
                        ],
                      ),
                      onTap: () {
                        debugPrint("ksadlk");
                        onTap(hasWon, id);
                      },
                    )),
                is2ndinning
                    ? Flexible(
                    flex: 3,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: hasWon
                            ? RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: teamWon,
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(text: ' Won by '),
                                TextSpan(
                                    text: wonBy,
                                    style: TextStyle(color: Colors.red)),
                              ]),
                        )
                            : RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: 'Need '),
                                TextSpan(
                                    text: needrun + ' runs ',
                                    style: TextStyle(color: Colors.red)),
                                TextSpan(text: 'from '),
                                TextSpan(
                                    text: needfrom + ' balls',
                                    style: TextStyle(color: Colors.red)),
                              ]),
                        ),
                      ),
                      onTap: () {
                        debugPrint("ksadlk");
                        onTap(hasWon, id);
                      },
                    ))
                    : new SizedBox(
                  width: 0,
                  height: 0,
                ),
              ],
            )));
  }


}