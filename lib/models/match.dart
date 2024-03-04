import 'package:cric_scorer/models/batter.dart';
import 'package:cric_scorer/models/bowler.dart';
import 'package:cric_scorer/models/over.dart';
import 'package:cric_scorer/utils/util.dart';


class TheMatch {
  // Have given this name to avoid clashes with dart:core Match class
  late int? id;
  late String team1url;
  late String team2url;
  late String team1;
  late String team2;
  late String toss;
  late String optTo;
  late bool hasWon;
  late int currentTeam;
  late int inning;
  late int totalOvers;
  late int no_of_players;
  late int currentBatterIndex;
  bool uploaded = false;
  Bowler? currentBowler;
  late List<int> score;
  late List<int> wickets;
  late List<double> over_count;
  late List<Batter> currentBatters;
  late List<List<List<dynamic>>> wicketOrder;
  late List<List<Batter>> batters;
  late List<List<Bowler>> bowlers;
  late List<List<Over>> Overs;
  late int date;

  TheMatch(this.team1, this.team1url, this.team2, this.team2url, this.toss,
      this.optTo, this.no_of_players, this.totalOvers,
      {this.id,
      overs,
      batters,
      bowlers,
      over_count,
      score,
      this.hasWon = false}) {
    // debugPrint("Match : $team1 , $team2");
    this.over_count = List.of([0.0, 0.0]);
    this.score = List.of([0, 0]);
    this.batters = List.of([[], []]);
    this.bowlers = List.of([[], []]);
    currentBatters = List.of([]);
    currentBowler = null;
    wicketOrder = [[], []];
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
    // debugPrint(currentTeam.toString() + toss + optTo);

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

    DateTime now = DateTime.now();
    date = timeNowMinutes(now);
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
          currentBatters = List.of(currentBatters.reversed);
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
            currentBatters = List.of(currentBatters.reversed);
            if (over_count[currentTeam] == totalOvers) {
              return false; // If over limit exeeded . Do not take new bowler.
            }

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
    // If batter retires
    if (wicketOrder[currentTeam].isNotEmpty) {
      var lastWicket = wicketOrder[currentTeam].last;
      if (lastWicket[0].outBy == "Retired Out") {
        // debugPrint("Wicket Order is:"+wicketOrder.toString());
        Batter batter = wicketOrder[currentTeam].removeLast()[0];
        currentBatters.remove(batters[currentTeam].removeLast());
        batter.outBy = 'Not Out';
        currentBatters.add(batter);
        currentBatters = List.of(currentBatters.reversed);
        return false;
      }
    }


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
          currentBatters = List.of(currentBatters.reversed);
          var bowlerName = Overs[currentTeam].last.bowlerName;
          Bowler? bowler;
          for (Bowler b in bowlers[currentTeam]) {
            if (b.name == bowlerName) {
              bowler = b;
              break;
            }
          }
          currentBowler = bowler;
        } else {
          over_count[currentTeam] -= 0.1;
        }
        currentBowler!
            .removeBowl(runOnBall, s, result[0].length != 1, runInOver);
      }

      //  Handle Wicket
      if (result[0].length != 1) {
        wickets[currentTeam] -= 1;
        // debugPrint("Wicket Order wicket:"+wicketOrder.toString());
        Batter batter = wicketOrder[currentTeam].removeLast()[0];
        currentBatters.remove(batters[currentTeam].removeLast());
        batter.outBy = 'Not Out';
        currentBatters.add(batter);
        currentBatters = List.of(currentBatters.reversed);
      }

      return false;
    } else {
      return true;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> theMatchMap = {};
    if (id != null) {
      theMatchMap['id'] = id;
    }
    theMatchMap['team1'] = team1;
    theMatchMap['team2'] = team2;
    theMatchMap['team1url'] = team1url;
    theMatchMap['team2url'] = team2url;
    theMatchMap['toss'] = toss;
    theMatchMap['optTo'] = optTo;
    theMatchMap['hasWon'] = hasWon.toString();
    theMatchMap['inning'] = inning;
    theMatchMap['no_of_players'] = no_of_players;
    theMatchMap['totalOvers'] = totalOvers;
    theMatchMap['currentBatterIndex'] = currentBatterIndex;
    theMatchMap['currentTeam'] = currentTeam;
    theMatchMap['currentBowler'] = currentBowler.toString();
    theMatchMap['uploaded'] = uploaded.toString();

    theMatchMap['score'] = score.join('#');
    theMatchMap['wickets'] = wickets.join('#');
    theMatchMap['over_count'] = over_count.join('#');
    theMatchMap['currentBatters'] = currentBatters.join("*");
    theMatchMap['date'] = date;

    String allWicketOrders = "";
    int len = wicketOrder[0].length;
    int count = 0;
    for (List<dynamic> lst in wicketOrder[0]) {
      allWicketOrders += lst.join("^");
      if (count++ != len - 1) {
        allWicketOrders += "%";
      }
    }
    allWicketOrders += "*";
    count = 0;
    len = wicketOrder[1].length;
    for (List<dynamic> lst in wicketOrder[1]) {
      allWicketOrders += lst.join("^");
      if (count++ != len - 1) {
        allWicketOrders += "%";
      }
    }
    // debugPrint("$allWicketOrders");
    // debugPrint("${wicketOrder.toString()}");
    theMatchMap['wicketOrder'] = allWicketOrders;

    // storing batters
    String allBattersString = "";
    count = 0;
    for (List<Batter> lst in batters) {
      count++;
      allBattersString += lst.join("*");
      if (count == 1) {
        allBattersString += "%";
      }
    }
    theMatchMap['batters'] = allBattersString;

    // storing bowlers
    String allBowlersString = "";
    count = 0;
    for (List<Bowler> lst in bowlers) {
      count++;
      allBowlersString += lst.join("*");
      if (count == 1) {
        allBowlersString += "%";
      }
    }

    theMatchMap['bowlers'] = allBowlersString;

    // storing Overs
    String allOversString = "";
    count = 0;
    for (List<Over> lst in Overs) {
      count++;
      allOversString += lst.join("*");
      if (count == 1) {
        allOversString += "%";
      }
    }

    theMatchMap['Overs'] = allOversString;

    return theMatchMap;
  }

  Map<String, dynamic> tolesserMap() {
    Map<String, dynamic> theMatchMap = {};
    theMatchMap['hasWon'] = hasWon.toString();
    theMatchMap['inning'] = inning;
    theMatchMap['currentBatterIndex'] = currentBatterIndex;
    theMatchMap['currentTeam'] = currentTeam;
    theMatchMap['currentBowler'] = currentBowler.toString();
    theMatchMap['uploaded'] = uploaded.toString();

    theMatchMap['score'] = score.join('#');
    theMatchMap['wickets'] = wickets.join('#');
    theMatchMap['over_count'] = over_count.join('#');
    theMatchMap['currentBatters'] = currentBatters.join("*");

    String allWicketOrders = "";
    int len = wicketOrder[0].length;
    int count = 0;
    for (List<dynamic> lst in wicketOrder[0]) {
      allWicketOrders += lst.join("^");
      if (count++ != len - 1) {
        allWicketOrders += "%";
      }
    }
    allWicketOrders += "*";
    count = 0;
    len = wicketOrder[1].length;
    for (List<dynamic> lst in wicketOrder[1]) {
      allWicketOrders += lst.join("^");
      if (count++ != len - 1) {
        allWicketOrders += "%";
      }
    }
    // debugPrint("$allWicketOrders");
    // debugPrint("wicket${wicketOrder.toString()}");
    theMatchMap['wicketOrder'] = allWicketOrders;

    // storing batters
    String allBattersString = "";
    count = 0;
    for (List<Batter> lst in batters) {
      count++;
      allBattersString += lst.join("*");
      if (count == 1) {
        allBattersString += "%";
      }
    }
    theMatchMap['batters'] = allBattersString;

    // storing bowlers
    String allBowlersString = "";
    count = 0;
    for (List<Bowler> lst in bowlers) {
      count++;
      allBowlersString += lst.join("*");
      if (count == 1) {
        allBowlersString += "%";
      }
    }

    theMatchMap['bowlers'] = allBowlersString;

    // storing Overs
    String allOversString = "";
    count = 0;
    for (List<Over> lst in Overs) {
      count++;
      allOversString += lst.join("*");
      if (count == 1) {
        allOversString += "%";
      }
    }

    theMatchMap['Overs'] = allOversString;

    return theMatchMap;
  }

  TheMatch.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    hasWon = bool.parse(map['hasWon']);
    team1 = map['team1'];
    team2 = map['team2'];
    team1url = map['team1url'];
    team2url = map['team2url'];
    toss = map['toss'];
    optTo = map['optTo'];
    no_of_players = map['no_of_players'];
    currentBatterIndex = map['currentBatterIndex'];
    inning = map['inning'];
    totalOvers = map['totalOvers'];
    currentTeam = map['currentTeam'];
    uploaded = bool.parse(map['uploaded']);
    if (map['currentBowler'] != "null") {
      currentBowler = Bowler.fromString(map['currentBowler']);
    }
    date = int.parse(map['date'].toString());

    List<String> arrayOfScore = map['score'].split('#');
    List<String> arrayOfWicket = map['wickets'].split('#');
    List<String> arrayOfOverCount = map['over_count'].split('#');
    List<String> arrayOfCurrentBatter = map['currentBatters'].split('*');
    List<String> arrayOfWicketOrder = map['wicketOrder'].split('*');

    //getting score
    score = [];
    for (String s in arrayOfScore) {
      score.add(int.parse(s));
    }

    //getting wickets
    wickets = [];
    for (String s in arrayOfWicket) {
      wickets.add(int.parse(s));
    }

    //getting over_count
    over_count = [];
    for (String s in arrayOfOverCount) {
      over_count.add(double.parse(s));
    }

    //getting currentBatters
    currentBatters = [];
    for (String s in arrayOfCurrentBatter) {
      if (s != "") currentBatters.add(Batter.fromString(s));
    }

    //getting wicketOrder
    wicketOrder = [[], []];
    int count = 0;
    for (String s in arrayOfWicketOrder) {
      if (s != "") {
        List<String> arrayOfEachOrder = s.split('%');
        // debugPrint("lst${arrayOfEachOrder}");
        for (String each in arrayOfEachOrder) {
          var eachLst = each.split('^');
          // debugPrint("${eachLst}");
          wicketOrder[count].add([Batter.fromString(eachLst[0]), eachLst[1]]);
        }
        count++;
      }
    }

    List<String> arrayOfArrayOfbatters = map['batters'].split('%');
    List<String> arrayOfArrayOfbowlers = map['bowlers'].split('%');
    List<String> arrayOfArrayOfOvers = map['Overs'].split('%');

    count = 0;
    // getting batters
    batters = [[], []];
    for (String s in arrayOfArrayOfbatters) {
      if (s != "") {
        List<String> arrayOfBatters = s.split('*');
        for (String s in arrayOfBatters) {
          batters[count].add(Batter.fromString(s));
        }
        count++;
      }
    }
    // debugPrint("FROMMATCH${batters.toString()}");

    count = 0;
    // getting bowlers
    bowlers = [[], []];
    for (String s in arrayOfArrayOfbowlers) {
      if (s != "") {
        List<String> arrayOfBowlers = s.split('*');
        // bowlers.add([]);
        for (String s in arrayOfBowlers) {
          bowlers[count].add(Bowler.fromString(s));
        }
        count++;
      }
    }

    count = 0;
    // getting Overs
    Overs = [[], []];
    for (String s in arrayOfArrayOfOvers) {
      if (s != "") {
        List<String> arrayOfOvers = s.split('*');
        // Overs.add([]);
        for (String s in arrayOfOvers) {
          Overs[count].add(Over.fromString(s));
        }
        count++;
      }
    }

    // debugPrint("Overs : ${Overs}");
  }
}
