import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../exports.dart';

class ScorePdfGenerator {
  final MatchViewModel viewModel = MatchViewModel();
  List<Batter> battersTeam1 = [];
  List<Batter> battersTeam2 = [];
  List<Bowler> bowlersTeam1 = [];
  List<Bowler> bowlersTeam2 = [];
  List<MapEntry<String,List<int>>> players = [];
  var wicketOrder1 = [[]];
  var wicketOrder2 = [[]];
  String team1 = "";
  String team2 = "";
  String score1 = "0-0";
  String score2 = "0-0";
  String overs1 = "0.0";
  String overs2 = "0.0";
  int isSelected = 0;
  String toDisplay = "1st innings";
  String runRate1 = "0.0";
  String runRate2 = "0.0";
  String extras1 = "0";
  String extras2 = "0";

  ScorePdfGenerator() {
    TheMatch match = viewModel.getCurrentMatch()!;
    battersTeam1 = match.batters[0];
    battersTeam2 = match.batters[1];
    bowlersTeam1 = match.bowlers[0];
    bowlersTeam2 = match.bowlers[1];
    wicketOrder1 = match.wicketOrder[0];
    wicketOrder2 = match.wicketOrder[1];
    players = match.players.entries.toList();
    players.sort((MapEntry a, MapEntry b) {
      int totalA = getTotal(a.value);
      int totalB = getTotal(b.value);
      if (totalA > totalB){
        return -1;
      }else if (totalB == totalA) {
        return 0;
      }else{
        return 1;
      }
    });
    team1 = match.team1;
    team2 = match.team2;
    score1 = "${match.score[0]}-${match.wickets[0]}";
    score2 = "${match.score[1]}-${match.wickets[1]}";
    overs1 = "${match.over_count[0].toStringAsFixed(1)} OVERS";
    overs2 = "${match.over_count[1].toStringAsFixed(1)} OVERS";
    double overInPercen = (match.totalOvers * 10).toInt() / 10 +
        (((match.totalOvers * 10).toInt() % 10) / 6);
    runRate1 = "${match.score[0] / overInPercen}";
    runRate2 = "${match.score[1] / overInPercen}";
    var cur = match.currentTeam;
    if (match.hasWon) {
      if (match.score[cur] >= match.score[(cur + 1) % 2]) {
        var team = cur == 0 ? match.team1 : match.team2;
        toDisplay =
            "$team won by ${(match.no_of_players - 1 - match.wickets[cur]).toString()} Wickets";
      } else {
        var team = cur == 0 ? match.team2 : match.team1;
        toDisplay =
            "$team won by ${(match.score[(cur + 1) % 2] - match.score[cur]).toString()} runs";
      }
    } else if (match.inning == 2) {
      var team = cur == 0 ? match.team1 : match.team2;
      String needrun =
          (match.score[(cur + 1) % 2] - match.score[cur] + 1).toString();
      int curBalls = ((match.over_count[cur] * 10).toInt() ~/ 10 * 6) +
          ((match.over_count[cur] * 10).toInt() % 10).toInt();
      int total = (match.totalOvers * 10).toInt();
      int totalBalls = ((total ~/ 10 * 6).toInt() + total % 10);
      String needfrom = (totalBalls - curBalls).toString();
      toDisplay = "$team needs $needrun runs from $needfrom balls";
    }

    Map<String, int> extras1Map = {"Nb": 0, "Lb": 0, "Wd": 0, "B": 0};
    Map<String, int> extras2Map = {"Nb": 0, "Lb": 0, "Wd": 0, "B": 0};
    int total_extra1 = 0;
    int total_extra2 = 0;

    for (var over in match.Overs[0]) {
      for (var bowl in over.bowls) {
        if (bowl[1] != "") {
          if (bowl[1] == "Nb")
            extras1Map[bowl[1]] = extras1Map[bowl[1]]! + 1;
          else if (bowl[1] == "Wd") {
            extras1Map[bowl[1]] = extras1Map[bowl[1]]! + int.parse(bowl[0]) + 1;
          } else {
            extras1Map[bowl[1]] = extras1Map[bowl[1]]! + int.parse(bowl[0]);
          }
          total_extra1 += 1;
        }
      }
    }
    for (var over in match.Overs[1]) {
      for (var bowl in over.bowls) {
        if (bowl[1] != "") {
          if (bowl[1] == "Nb") {
            extras2Map[bowl[1]] = extras2Map[bowl[1]]! + 1;
          } else if (bowl[1] == "Wd") {
            extras2Map[bowl[1]] = extras2Map[bowl[1]]! + int.parse(bowl[0]) + 1;
          } else {
            extras2Map[bowl[1]] = extras2Map[bowl[1]]! + int.parse(bowl[0]);
          }
          total_extra2 += 1;
        }
      }
    }

    extras1 = "($extras1Map) $total_extra1";
    extras2 = "($extras1Map) $total_extra2";
  }

  generatePdf(pw.Document pdf) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => <pw.Widget>[
          _buildHeader(),
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                _buildTeamSection(
                  team: team1,
                  score: score1,
                  overs: overs1,
                  batters: battersTeam1,
                  extras: extras1,
                  runRate: runRate1,
                  bowlers: bowlersTeam1,
                ),
                pw.SizedBox(height: 10),
                _buildTeamSection(
                  team: team2,
                  score: score2,
                  overs: overs2,
                  batters: battersTeam2,
                  extras: extras2,
                  runRate: runRate2,
                  bowlers: bowlersTeam2,
                ),
                PdfUtil.getPlayers(players),
              ],
            ),
          )
        ],
      ),
    );
  }

  pw.Widget _buildHeader() {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("ScoreBoard", style: pw.TextStyle(fontSize: 18)),
          pw.Text(
            toDisplay,
            style: const pw.TextStyle(color: PdfColors.redAccent),
            textAlign: pw.TextAlign.end,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTeamSection({
    required String team,
    required String score,
    required String overs,
    required List<Batter> batters,
    required String extras,
    required String runRate,
    required List<Bowler> bowlers,
  }) {
    return pw.Column(
      children: [
        _buildTeamHeader(team: team, score: score, overs: overs),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
          child: pw.Column(
            children: [
              pw.SizedBox(height: 1),
              PdfUtil.getBatter(batters),
              pw.SizedBox(height: 2),
              _buildExtrasRow(extras: extras, runRate: runRate),
              pw.SizedBox(height: 5),
              PdfUtil.getBowlers(bowlers),
            ],
          ),
        ),
      ],
    );
  }



  pw.Widget _buildTeamHeader({
    required String team,
    required String score,
    required String overs,
  }) {
    return pw.Container(
      color: PdfColors.green,
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(team, style: const pw.TextStyle(color: PdfColors.white, fontSize: 15)),
            pw.Text(score, style: const pw.TextStyle(color: PdfColors.white)),
            pw.Text(overs, style: const pw.TextStyle(color: PdfColors.white)),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildExtrasRow({required String extras, required String runRate}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(extras),
        pw.Text("   Run  Rate : $runRate  "),
      ],
    );
  }

}
