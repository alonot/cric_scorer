import 'dart:io';

import 'package:cric_scorer/Components/ScorePdfGenerator.dart';
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class CardMatch extends StatelessWidget {
  String team1Url = "assests/CSK.jpg";
  String team2Url = "assests/RCB.jpg";
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
  final Function(bool) setLoading;

  CardMatch(this.onTap, this.onTapUpload, this.setLoading,{TheMatch? match, super.key}) {
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
      // debugPrint("$overs,$overCount");
      needfrom = overCount.toString();

      team1Color =
          match.currentTeam == 0 ? Colors.white : const Color(0xff9b9b9b);
      team2Color =
          match.currentTeam == 1 ? Colors.white : const Color(0xff9b9b9b);
      is2ndinning = match.inning == 2;
      hasWon = match.hasWon;
      wonBy = '';
      if (hasWon) {
        int cur = match.currentTeam;
        if (match.score[cur] > match.score[(cur + 1) % 2]) {
          teamWon = cur == 0 ? match.team1 : match.team2;
          wonBy = "${match.no_of_players - 1 - match.wickets[cur]} wickets";
        } else if(match.score[cur] != match.score[(cur + 1) % 2]) {
          teamWon = cur == 0 ? match.team2 : match.team1;
          wonBy = "${match.score[(cur + 1) % 2] - match.score[cur]} runs";
        }else{
          teamWon  = "";
          wonBy = "Nobody";
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
            Flexible(
                flex: 2,
                child: ListTile(
                    trailing: SizedBox(
                      width: 100,
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                // debugPrint("Here");
                                setLoading(true);
                                try {
                                  viewModel.setCurrentMatch(
                                      (await viewModel.getMatch(id!))!);
                                  final pdf = pw.Document();
                                  ScorePdfGenerator().generatePdf(pdf);
                                  String path = await savePdf(pdf);
                                  debugPrint("File Path ${path}");
                                  await Share.shareXFiles([XFile(path)],
                                      text: "ScoreCard",
                                      subject: "Sharing ScoreCard");
                                }catch (Exception){
                                  ScaffoldMessenger.of(context).showSnackBar(Util.getsnackbar('Something went Wrong.'));
                                }
                                setLoading(false);
                              },
                              constraints:
                              BoxConstraints(maxHeight: 35, maxWidth: 35),
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              )),
                          !uploaded
                              ? IconButton(
                                  onPressed: () {
                                    onTapUpload(hasWon, id);
                                  },
                                  constraints: BoxConstraints(
                                      maxHeight: 35, maxWidth: 35),
                                  icon: const Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  ),
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                    visualDensity: const VisualDensity(vertical: -4))),


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
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.only(right: 0),
                              ),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(team1Url),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ), // Team 1 Avatar
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  team1,
                                  style: TextStyle(
                                      color: team1Color, fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  score1,
                                  style: TextStyle(
                                      color: team1Color,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '$overs1 OVERS',
                                  style: TextStyle(
                                      color: team1Color, fontSize: 12),
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    team2,
                                    style: TextStyle(
                                        color: team2Color, fontSize: 12),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(score2,
                                      style: TextStyle(
                                          color: team2Color,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('$overs2 OVERS',
                                      style: TextStyle(
                                          color: team2Color, fontSize: 12),
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
                                padding: const EdgeInsets.only(right: 0),
                              ),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(team2Url),
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
                    // debugPrint("ksadlk");
                    onTap(hasWon, id);
                  },
                )),
            is2ndinning
                ? Flexible(
                    flex: 3,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: hasWon
                            ? RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: teamWon,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      const TextSpan(text: ' Won by '),
                                      TextSpan(
                                          text: wonBy,
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ]),
                              )
                            : RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Need '),
                                      TextSpan(
                                          text: '$needrun runs ',
                                          style: const TextStyle(
                                              color: Colors.red)),
                                      const TextSpan(text: 'from '),
                                      TextSpan(
                                          text: '$needfrom balls',
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ]),
                              ),
                      ),
                      onTap: () {
                        // debugPrint("ksadlk");
                        onTap(hasWon, id);
                      },
                    ))
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        )));
  }

  Future<String> savePdf(pw.Document pdf) async {
    Directory tempDirectory = await getTemporaryDirectory();
    String tempPath = tempDirectory.path;
    File file = File("${tempPath}/scoreBoard.pdf");
    file.writeAsBytesSync(await pdf.save());
    return "${tempPath}/scoreBoard.pdf";
  }
}
