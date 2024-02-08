import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:cric_scorer/models/Over.dart';

class TheMatch {
  // Have given this name to avoid clashes with dart:core Match class
  String team1url;
  String team2url;
  String team1;
  String team2;
  String toss;
  String optTo;
  late int currentTeam;
  late int inning;
  int totalOvers;
  late List<double> over_count;
  int no_of_players;
  late int currentBatterIndex;
  late List<int> score;
  late List<int> wickets;
  late List<Batter> currentBatters;
  late List<Batter> wicketOrder;
  late Bowler? currentBowler;
  late List<List<Batter>> batters;
  late List<List<Bowler>> bowlers;
  late List<List<Over>> Overs;

  TheMatch(this.team1, this.team1url, this.team2, this.team2url, this.toss,
      this.optTo, this.no_of_players, this.totalOvers,
      {overs, batters, bowlers, over_count, score}) {
    this.over_count = List.of([0.0, 0.0]);
    this.score = List.of([0, 0]);
    this.batters = List.of([[], []]);
    this.bowlers = List.of([[], []]);
    currentBatters = List.of([]);
    currentBowler = null;
    wicketOrder = [];
    currentBatterIndex = 0;
    Overs = List.of([[], []]);
    inning = 1;
    wickets = [0, 0];
    currentTeam = toss == "Team 1"
        ? optTo == "Bat"
            ? 0
            : 1
        : optTo == "Bat"
            ? 1
            : 0;
    print(currentTeam.toString() + toss + optTo);

    if (over_count != null) {
      this.over_count = over_count;
    }
    if (bowlers != null) {
      this.bowlers = bowlers;
    }
    if (batters != null) {
      this.batters = batters;
    }
    if (overs != null) {
      this.over_count = overs;
    }
    if (score != null) {
      this.score = score;
    }
  }

  bool addBatter(Batter batter) {
    if (wickets[currentTeam] != no_of_players - 1 &&
        over_count[currentTeam] != totalOvers) {
      currentBatters.add(batter);
      batters[currentTeam].add(batter);
      return true;
    } else {
      return false;
    }
  }

  bool addBowler(Bowler bowler) {
    if (wickets[currentTeam] != no_of_players - 1 &&
        over_count[currentTeam] != totalOvers) {
      currentBowler = bowler;
      bowlers[currentTeam].add(bowler);
      return true;
    } else {
      return false;
    }
  }

  bool addScore(String s, String run) {
    var count = over_count[currentTeam];
    if (count < totalOvers) {
      var runOnBall = int.parse(run[0]);
      if (s == "" || s == "Nb") {
        currentBatters[currentBatterIndex]
            .addRun(runOnBall); // Add Batter's run and bowl
        // Checking for change of strike
        if (runOnBall % 2 == 1) {
          currentBatters= List.of(currentBatters.reversed);
        }
      }

      // Handling extra runs
      if (s == "Nb" || s == "Wd") {
        runOnBall++;
      }
      // Adding team's score
      score[currentTeam] += runOnBall;

      // Handling overCount of the current Team
      if (Overs[currentTeam].isNotEmpty) {
        // Adding Bowler stats
        Overs[currentTeam].last.wasMaiden = runOnBall == 0;
        currentBowler!.addBowl(
            runOnBall, s, run.length != 1, Overs[currentTeam].last.runs);
        Overs[currentTeam].last.bowls.add([run, s]);
        Overs[currentTeam].last.runs += runOnBall;
        if (s != "Wd" && s != "Nb") {
          if ((count * 10).toInt() % 10 == 5) {
            over_count[currentTeam] += 0.5;
            if (over_count[currentTeam] == totalOvers)
              return false; // If over limit exeeded . Do not take new bowler.

            return true; // signal to get a new bowler
          } else {
            over_count[currentTeam] += 0.1;
          }
        }
      }
    }
    return false;
  }

  bool popScore() {
    var count = over_count[currentTeam];
    if (Overs[currentTeam].isNotEmpty) {
      List<dynamic> result;
      int runInOver = 1;
      // Removing the ball
      if (Overs[currentTeam].last.bowls.isNotEmpty) {
        // If in the latest over any ball is left

        result = Overs[currentTeam].last.bowls.removeLast();
        Overs[currentTeam].last.runs -= int.parse(result[0][0]);
        runInOver = Overs[currentTeam].last.wasMaiden ? 0 : 1;
      } else {
        // pop the latest over
          Overs[currentTeam].removeLast();
          // check if after removing that lates over any more overs are left to b removed or not
          if (Overs[currentTeam].isNotEmpty) {
            result = Overs[currentTeam].last.bowls.removeLast();
            Overs[currentTeam].last.runs -= int.parse(result[0][0]);
            runInOver = Overs[currentTeam].last.wasMaiden ? 0 : 1;
          } else {
            // If no then we have reached 0.0 ... return the function
            return true;
          }
      }

      var runOnBall = int.parse(result[0][0]);
      var s = result[1];

      //  Handle Wicket
      if (result[0].length != 1){
        var batter = wicketOrder.removeLast();
        currentBatters.remove(batters[currentTeam].removeLast());
        currentBatters.add(batter);
      }

      // decreasing the batters run
      if (s == "" || s == "Nb") {
        if (runOnBall % 2 == 1) {
          currentBatters = List.of(currentBatters.reversed);
        }
        currentBatters[currentBatterIndex].removeRun(runOnBall);
      }

      // Handling extras
      if (s == "Nb" || s == "Wd") {
        runOnBall++;
      }

      // Handling the team score
      score[currentTeam] -= runOnBall;

      // decreasing the over count
      if (s != "Wd" && s != "Nb") {
        if ((count * 10).toInt() % 10 == 0) {
          over_count[currentTeam] -= 0.5;
          var bowlerName= Overs[currentTeam].last.bowlerName;
          Bowler? bowler;
          for (Bowler b in bowlers[currentTeam]){
            if (b.name == bowlerName){
              bowler = b;
              break;
            }
          }
          currentBowler = bowler;
        } else {
          over_count[currentTeam] -= 0.1;
        }
      currentBowler!.removeBowl(runOnBall, s, result[0].length != 1, runInOver);
      }

    return false;
    }else{
      return true;
    }
  }
}
