import '../exports.dart';


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
  late double totalOvers;
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

  void addBatter(Batter batter) {
      currentBatters.add(batter);
      batters[currentTeam].add(batter);
  }

  void addBowler(Bowler bowler) {
      currentBowler = bowler;
      bowlers[currentTeam].add(bowler);
  }

  void addScore(String s, String run) {
    var runOnBall = int.parse(run[0]);
    if (s == "" || s == "Nb") {
      currentBatters[0].addRun(runOnBall); // Add Batter's run and bowl
      // Checking for change of strike
      if (runOnBall % 2 == 1) {
        currentBatters = List.of(currentBatters.reversed);
      }
    }

    // Handling extra runs
    if (s == "Nb" || s == "Wd") {
      runOnBall++;
    }
    var over = Overs[currentTeam].last;
    if(s != "Wd" && s != "Nb"){
      // increase over count
      over_count[currentTeam] +=0.1;
      currentBowler!.addBowl(
          runOnBall, true);
    }else {
      currentBowler!.addBowl(
          runOnBall, false);
    }
    over.bowls.add([run, s]);
    over.runs += runOnBall;
    score[currentTeam] += runOnBall;

    over_count[currentTeam] = double.parse(over_count[currentTeam].toStringAsFixed(2));

  }

  bool popScore() {

    if (Overs.isNotEmpty){
      var lastOver = Overs[currentTeam].last;
      var bowl = lastOver.bowls.last;
      lastOver.bowls.removeLast();
      if (bowl[0] == "Retired Out"){
        // retreive the batter from wicket order
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
      }
      else{
        var run = int.parse(bowl[0][0]);
        var s = bowl[1];
        if (s == "" || s == "Nb") {
          // Checking for change of strike
          if (run % 2 == 1) {
            currentBatters = List.of(currentBatters.reversed);
          }
          currentBatters[0].removeRun(run); // Add Batter's run and bowl
        }
        // Handling extra runs
        if (s == "Nb" || s == "Wd") {
          run++;
        }
        var over = Overs[currentTeam].last;
        if(s != "Wd" && s != "Nb"){
          // increase over count
          over_count[currentTeam] -=0.1;
          currentBowler!.removeBowl(
              run, true);
        }else {
          currentBowler!.removeBowl(
              run, false);
        }

        //  Handle Wicket
        debugPrint(LOGSTRING + s);
        if (bowl[0].length != 1) {
          wickets[currentTeam] -= 1;
          // debugPrint("Wicket Order wicket:"+wicketOrder.toString());
          Batter batter = wicketOrder[currentTeam].removeLast()[0];
          currentBatters.remove(batters[currentTeam].removeLast());
          batter.outBy = 'Not Out';
          currentBatters.add(batter);
          currentBatters = List.of(currentBatters.reversed);
        }

        score[currentTeam] -= run;
        lastOver.runs -= run;

        over_count[currentTeam] = double.parse(over_count[currentTeam].toStringAsFixed(2));
      }
    }
    return false;


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
    totalOvers = (map['totalOvers']).toDouble();
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
