import 'package:pdf/widgets.dart';

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
  late Map<String, List<int>> players;  //[ 1stBat, 2ndBat, 1stBowl, 2ndBowl, bat1st(0/1), bat2nd(0/1),  bowl1st(0/1), bowl2nd(0/1) ]
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
    players = {};
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

      if (! players.containsKey(batter.name)){
        players[batter.name] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
      }
      batters[currentTeam].add(batter);
  }

  void addBowler(Bowler bowler) {
      currentBowler = bowler;
      if (! players.containsKey(bowler.name)){
        players[bowler.name] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
      }
      bowlers[currentTeam].add(bowler);
  }

  /// Updates Points of the player on wicket
  void updateWicketPoints(String type, Batter batter, Bowler bowler, String helperName){
    updateBatterStrikeRatePoints(batter);
    //
    if (batter.runs == 0){
      this.players[batter.name]![inning - 1] += -4;
    }
    //
    if (this.players[bowler.name]![inning + 1] == SCORE_MIN){
      this.players[bowler.name]![inning + 1] = 0;
    }

    switch(type){
      case "Hit Wicket":
      case "LBW":
      case "Bowled":
        this.players[bowler.name]![inning + 1] += 25;
        break;
      case "Stumping":
      case "Catch Out":
        this.players[bowler.name]![inning + 1] += 25;
      case 'Run out':
        if (!players.containsKey(helperName) ){
          players[helperName] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
        }
        if (players[helperName]![inning + 1] == SCORE_MIN){
          players[helperName]![inning + 1] = 0;
        }
        players[helperName]![inning + 1] +=  10;
        break;
    }
    if (bowler.wickets == 4){
        this.players[bowler.name]![inning + 1] += 8;
    }else if (bowler.wickets == 6){
        this.players[bowler.name]![inning + 1] += 8;
    }
  }

  /// Pop Points on wicket
  void popWicketPoints(String type, Batter batter, Bowler bowler){
    popBatterStrikeRatePoints(batter);
    //
    if (batter.runs == 0){
      players[batter.name]![inning - 1] += -4;
    }

    String wicketType = type.split(' ')[0];


    switch(wicketType){
      case "Hit":
      case "LBW":
      case "b":
        players[bowler.name]![inning + 1] -= 25;
        break;
      case "St":
      case "c":
        players[bowler.name]![inning + 1] -= 25;
      case 'run':
        var helperName = type.split('(')[0].split(')')[0];
        if (players.containsKey(helperName) ){
          players[helperName]![inning + 1] -=  10;
        }
        break;
    }
    if (bowler.wickets == 4){
      players[bowler.name]![inning + 1] -= 8;
    }else if (bowler.wickets == 6){
      players[bowler.name]![inning + 1] -= 8;
    }
  }

  /// Updates Points of the player on Over
  void updateBowlerEconomyPoints(Bowler bowler, bool wasMaiden){
    double economy = bowler.economy;
    int score = 0;
    if (wasMaiden){
      score = 12;
    }
    if(economy < 4){
      score += 6;
    }else if (economy < 6){
      score += 4;
    }else if (economy < 9){
      score += 1;
    }else {
      score += -1;
    }
    if (!players.containsKey(bowler.name)){
      players[bowler.name] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
    }
    if (players[bowler.name]![inning + 1] == SCORE_MIN){
      players[bowler.name]![inning + 1] = 0;
    }
    players[bowler.name]![inning + 1] += score;
  }

  /// Pops Points of player on Over
  void popBowlerEconomyPoints(Bowler bowler, bool wasMaiden){
    double economy = bowler.economy;
    int score = 0;
    if (wasMaiden){
      score = 12;
    }
    if(economy < 4){
      score += 6;
    }else if (economy < 6){
      score += 4;
    }else if (economy < 9){
      score += 1;
    }else {
      score += -1;
    }
    if (players.containsKey(bowler.name)){
      players[bowler.name]![inning + 1] -= score;
    }
  }

  /// Updates Points of batter it is called on wicket or on every 6th ball of batter
  void updateBatterStrikeRatePoints(Batter batter) {
    int score = 0;
    double stRate = batter.strikeRate;
    if (stRate < 50){
      score = -5;
    }else if (stRate < 75){
      score = -3;
    }else if (stRate < 100){
      score = -1;
    }else if (stRate < 125){
      score = 1;
    }else if (stRate < 150){
      score = 3;
    }else{
      score = 5;
    }
    if (!players.containsKey(batter.name)){
      players[batter.name] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
    }
    if (players[batter.name]![inning - 1] == SCORE_MIN){
      players[batter.name]![inning - 1] = 0;
    }
    players[batter.name]![inning - 1] += score;
  }

  /// Pops the Points due to strike Rate
  void popBatterStrikeRatePoints(Batter batter) {
    int score = 0;
    double stRate = batter.strikeRate;
    if (stRate < 50){
      score = -5;
    }else if (stRate < 75){
      score = -3;
    }else if (stRate < 100){
      score = -1;
    }else if (stRate < 125){
      score = 1;
    }else if (stRate < 150){
      score = 3;
    }else{
      score = 5;
    }
    if (players.containsKey(batter.name)){
      players[batter.name]![inning - 1] -= score;
    }
  }


  /// Updates batter points on that ball
  void updatePointsBeforeUpdate(Batter batter, String runString){
    // Reward/ Penalty for Strike Rate and Economy will be calculated at the end of the over(for batter it will be 6 balls and after wicket)
    //NOTE: Wicket score will be credited separately from the getWicket Screen

    var runOnBall = int.parse(runString[0]);
    int newRun = batter.runs + runOnBall;
    int batterBallScore = 0;

    if (newRun >= 100){
      batterBallScore +=12;
    }else if (newRun >= 50){
      batterBallScore += 6;
    }

    batterBallScore += runOnBall;

    if (runOnBall == 6){
      batterBallScore += 2;
    }else if (runOnBall >= 4){
      batterBallScore += 1;
    }
    if (!players.containsKey(batter.name)){
      players[batter.name] = [SCORE_MIN, SCORE_MIN, SCORE_MIN, SCORE_MIN];
    }
    if (players[batter.name]![inning - 1] == SCORE_MIN){
      players[batter.name]![inning - 1] = 0;
    }
    players[batter.name]![inning - 1] += batterBallScore;
  }

  /// Pop Points of batter  on that ball
  void popPointsBeforeUpdate(Batter batter, String runString){

    var runOnBall = int.parse(runString[0]);
    int newRun = batter.runs + runOnBall;
    int batterBallScore = 0;

    if (newRun >= 100){
      batterBallScore +=12;
    }else if (newRun >= 50){
      batterBallScore += 6;
    }

    batterBallScore += runOnBall;

    if (runOnBall == 6){
      batterBallScore += 2;
    }else if (runOnBall >= 4){
      batterBallScore += 1;
    }

    if (players.containsKey(batter.name)){
      players[batter.name]![inning - 1] -= batterBallScore;
    }
  }



  void addScore(String s, String run) {
    var runOnBall = int.parse(run[0]);


    if (s == "" || s == "Nb") {
      updatePointsBeforeUpdate(currentBatters[0], run); // updates point for this batter
      currentBatters[0].addRun(runOnBall); // Add Batter's run and bowl
    }else if (s == "LB" || s == "B"){
      currentBatters[0].addRun(0);
    }
    // Checking for change of strike
    if (runOnBall % 2 == 1) {
      currentBatters = List.of(currentBatters.reversed);
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

    if ((over_count[currentTeam] * 10) % 10 == 6){
      // Over finished
      bool wasMaiden = false;

      if (Overs[currentTeam].last.runs == 0){
        currentBowler!.maidens ++;
        wasMaiden = true;
      }
      updateBowlerEconomyPoints(currentBowler!, wasMaiden);
    }


    for (Batter b in currentBatters){
      if (b.balls % 6 == 0 && b.balls != 0){
        updateBatterStrikeRatePoints(b);
      }
    }

  }

  bool popScore() {

    if (Overs.isNotEmpty){
      var lastOver = Overs[currentTeam].last;
      var bowl = lastOver.bowls.lastOrNull;
      if (bowl == null){
        return false;
      }
      lastOver.bowls.removeLast();

      if (bowl[1] == "Retired Out"){
        // retreive the batter from wicket order
        // If batter retires
        if (wicketOrder[currentTeam].isNotEmpty) {
          var lastWicket = wicketOrder[currentTeam].last;
          if (lastWicket[0].outBy == "Retired Out") {
            // debugPrint("Wicket Order is:"+wicketOrder.toString());
            Batter batter = wicketOrder[currentTeam].removeLast()[0];
            // debugPrint(batters[currentTeam].last.toString());
            int pos = currentBatters.indexOf(batters[currentTeam].removeLast());
            if (pos != -1) {
              batter.outBy = 'Not Out';
              currentBatters[pos] = batter;
              return false;
            }
          }
        }
      }
      else{
        var run = int.parse(bowl[0][0]);
        var s = bowl[1];

        //  Handle Wicket
        // debugPrint(LOGSTRING + s);
        if (bowl[0].length != 1) {
          wickets[currentTeam] -= 1;
          // debugPrint("Wicket Order wicket:"+wicketOrder.toString());
          var wicket_order = wicketOrder[currentTeam].removeLast();
          Batter batter = wicket_order[0];
          Batter b = batters[currentTeam].removeLast();
          int pos = currentBatters.indexOf(b);
          if (b.balls != 0){
            b.outBy = "Retired Out";
            batters[currentTeam].add(b);
          }
          // int pos = 0;
          currentBatters[pos] = batter;
          batters[currentTeam].remove(batter);
          batters[currentTeam].add(batter);
          if (!batter.outBy.startsWith('run')){
            currentBowler!.wickets --;
          }
          batter.outBy = 'Not Out';
          popWicketPoints(batter.outBy, batter, currentBowler!);
        }

        for (Batter b in currentBatters){
          if (b.balls % 6 == 0 && b.balls != 0){
            popBatterStrikeRatePoints(b);
          }
        }

        // Checking for change of strike
        if (run % 2 == 1) {
          currentBatters = List.of(currentBatters.reversed);
        }
        if (s == "" || s == "Nb") {
          currentBatters[0].removeRun(run); // Remove Batter's run and bowl
          popPointsBeforeUpdate(currentBatters[0], bowl[0]);
        }else if (s == "LB" || s == "B"){
          currentBatters[0].removeRun(0);
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



        over_count[currentTeam] = double.parse(over_count[currentTeam].toStringAsFixed(2));

        score[currentTeam] -= run;
        lastOver.runs -= run;

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

    var players_string = "";
    int len = players.length;
    int count = 0;
    for (var ply_entity in players.entries){
      players_string +=  "${ply_entity.key}#${ply_entity.value.join("/")}";
      if (count++ != len - 1){
        players_string += "*";
      }
    }
    theMatchMap["players"] = players_string;

    String allWicketOrders = "";
    len = wicketOrder[0].length;
    count = 0;
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

    var players_string = "";
    int len = players.length;
    int count = 0;
    for (var ply_entity in players.entries){
      players_string +=  "${ply_entity.key}#${ply_entity.value.join("/")}";
      if (count++ != len - 1){
        players_string += "*";
      }
    }
    theMatchMap["players"] = players_string;

    String allWicketOrders = "";
    len = wicketOrder[0].length;
    count = 0;
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
    List<String> arrayOfPlayers = map['players'].split('*');


    // getting players
    players = {};
    for (String p in arrayOfPlayers){
      if (p != "") {
        var arrayOfPly = p.split('#');
        players[arrayOfPly[0]] =
            arrayOfPly[1].split('/').map((e) => int.parse(e)).toList();
      }
    }

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
