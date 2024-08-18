import 'dart:collection';

import '../exports.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final MatchViewModel viewModel = MatchViewModel();
  TheMatch? match;
  bool isLoading = false;

  _MatchPageState() {
    match = viewModel.getCurrentMatch();
  }

  void swap() async {
    workQueue.add([SWAP]);
    workQueue.add([SAVE]);
    queryResolver();
  }

  void retire() async {
    workQueue.add([RETIRE]);
    workQueue.add([SAVE]);
    queryResolver();
  }

  void endInning() {
    workQueue.add([CHECKOVER, UPDATE]);
    workQueue.add([END]);
    workQueue.add([SAVE]);
    queryResolver();
  }

  Queue<List<dynamic>> workQueue = Queue();

  Future<void> checkOver(String action) async {
    /**
        Checks if Over is finished or not
        If Finished, then opens NextBowler
     */
    if (match != null) {
      double? over = match?.over_count[match!.currentTeam];
      // debugPrint("Over : $over");
      switch (action) {
        case UPDATE:
          if ((over! * 10) % 10 == 6) {
            workQueue.clear();
            // over finished

            match!.over_count[match!.currentTeam] += 0.4;
            match!.currentBowler!.overs += 0.4;
            match!.currentBatters = List.of(match!.currentBatters.reversed);
            // open New Bowler
            workQueue.add([CHECKINNING]);
            workQueue.add([GETBOWLER]);
          }
          break;
        case POP:
          if ((over! * 10) % 10 == 0) {
            // Over finished ask for new Bowler
            // if return is true else we got back button
            // then do Nothing

            // pop this bowler out
            var currentTeam = match!.currentTeam;
            if (match!.Overs[currentTeam].length != 1) {
              var current_bowler = match!.Overs[currentTeam].last.bowlerName;
              match!.Overs[currentTeam].removeLast();
              match!.over_count[currentTeam] -= 0.4;
              match!.currentBatters = List.of(match!.currentBatters.reversed);
              var lastOver = match!.Overs[currentTeam].last;
              var bowlerName = lastOver.bowlerName;
              Bowler? bowler;
              Bowler? toRemove;
              for (Bowler b in match!.bowlers[currentTeam]) {
                if (b.name == bowlerName) {
                  bowler = b;
                }
                if (b.name == current_bowler) {
                  toRemove = b;
                }
              }
              if (toRemove != null) {
                if (toRemove.overs == 0.0)
              {
                match!.bowlers[currentTeam].remove(toRemove);
              }
            }
              match!.currentBowler = bowler;
              if (bowler != null) {
                bool wasMaiden = false;
                bowler.overs -=0.4;

                if (lastOver.runs == 0) {
                  bowler.maidens--;
                  wasMaiden = true;
                }
                match!.popBowlerEconomyPoints(bowler, wasMaiden);
              }
            }
          }
      }
    }
  }

  Future<bool> checkInning() async {
    /**
        Checks if Inning is finished or not
        If Finished, then opens Winner Page or Openers Page
     */
    // debugPrint(LOGSTRING + " Heere");
    if (match != null) {
      double? over = match?.over_count[match!.currentTeam];
      if (over == match!.totalOvers ||
          match!.wickets[match!.currentTeam] == match!.no_of_players - 1) {
        if (match!.inning == 1) {
          // changing inning
          match!.inning = 2;
          match!.currentTeam++;
          match!.currentTeam %= 2;
          // Getting Openers
          // updates currentBatter,currentBowler, Overs
          await Navigator.pushNamedAndRemoveUntil(
                  context, Util.getOpenersRoute, (route) => false)
              .then((value) => setState(() {}));
        }
      }
      return await checkWinner();

    }
    return false;
  }

  Future<bool> checkWinner() async {
    // Winner Calculation
    ////////////////////////////////////

    var cur = match!.currentTeam;
    var won = true;
    if (match!.inning == 1) {
      return false;
    }
    if (match!.score[cur] >= match!.score[(cur + 1) % 2] + 1) { 
      // batting team won
      Util.team = cur == 0 ? match!.team1 : match!.team2;
      Util.wonBy = "${match!.no_of_players - 1 - match!.wickets[cur]} wickets";
    } else if (match!.wickets[match!.currentTeam] == match!.no_of_players - 1 ||
        (match!.score[cur] != match!.score[(cur + 1) % 2] && match!.over_count[match!.currentTeam] == match!.totalOvers)) {
      // bowling team won
      Util.team = cur == 0 ? match!.team2 : match!.team1;
      Util.wonBy = "${match!.score[(cur + 1) % 2] - match!.score[cur]} runs";
    } else if (match!.score[cur] == match!.score[(cur + 1) % 2] && match!.over_count[match!.currentTeam] == match!.totalOvers) {
      // match drawn
      Util.team = "";
      Util.wonBy = "Nobody";
    } else {
      won = false;
    }
    ////////////////////////////////////////
    match!.hasWon = won;
    if (won) {
      await viewModel.updateMatch(match!);
      viewModel.updateLocalPlayersStats(match!); // updates all the players
       await Navigator.popAndPushNamed(context, Util.winnerPageRoute);
    }
    return won;
  }

  Future<void> getBowler() async {
    /**
     * Opens the Page to get the New Bowler
     */
    // updates currentBowler, Overs
    await Navigator.pushNamed(context, Util.getBowlerRoute)
        .then((value) => {setState(() {})});
  }

  Future<void> getNewBatter() async {
    /**
     * Opens the Page to get the New Batter
     */
    match!.wickets[match!.currentTeam] += 1;
    // This adds the new Batter to BatterList
    // and updates Wicket Order
    await Navigator.pushNamed(context, Util.wicketRoute)
        .then((value) => {setState(() {})});
  }

  void endInningHere() async {
    /**
     * Ends the Inning Here
     */
    var curr = match!.currentTeam;
    bool? result = await displayDialog(
        'Are you sure? Target will be ${match!.score[curr]}'
        ' in  ${match!.over_count[curr]}',
        context);
    if (result != null && !result) {
      return;
    }
    match!.totalOvers = match!.over_count[curr];
  }

  void queryResolver() async {
    setState(() {
      isLoading = true;
    });
    while (workQueue.isNotEmpty) {
      var currWork = workQueue.removeFirst();
      debugPrint(LOGSTRING + " :> " + currWork[0]);
      switch (currWork[0]) {
        case CHECKOVER:
          await checkOver(currWork[1]);
          break;
        case CHECKWINNER:
          await checkWinner();
          break;
        case CHECKINNING:
          if (await checkInning()){
            workQueue.clear();
            break;
          }
          break;
        case GETBOWLER:
          await getBowler();
          break;
        case WICKET:
          await getNewBatter();
          break;
        case END:
          endInningHere();
          break;

        case SAVE:
          await viewModel.updateMatch(match!);
          break;
        case UPDATE:
          match!.addScore(currWork[1], currWork[2]);
          break;
        case POP:
          match!.popScore();
          break;
        case RETIRE:
          await Navigator.pushNamed(context, Util.getBatterRoute)
              .then((value) => {setState(() {})});
          break;
        case SWAP:
          match!.currentBatters = List.of(match!.currentBatters.reversed);
          break;

        default:
          break;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateScore(String s, String run) async {
    /**
     * Updates the score and calls other pages if needed.
     */
    debugPrint(LOGSTRING + s + "," + run);

    // Check Over
    workQueue.add([CHECKOVER, UPDATE]);

    // Update the score
    workQueue.add([UPDATE, s, run]);

    // Check Wicket
    if (run.contains("OUT")) {
      workQueue.add([WICKET]);
      workQueue.add([CHECKINNING]);
      workQueue.add([SAVE]);
    }

    // Check Over
    workQueue.add([CHECKOVER, UPDATE]);

    // Check If inning Ended
    workQueue.add([CHECKWINNER]);

    // save the Match
    workQueue.add([SAVE]);

    // resolve the queries
    queryResolver();
  }

  void popScore() async {
    bool? result = await displayDialog('Are you sure?', context);
    if (result != null && !result) {
      return;
    }
    // check for Over
    workQueue.add([CHECKOVER, POP]);
    // pop 1 ball out
    workQueue.add([POP]);
    // check for Over
    workQueue.add([CHECKOVER, POP]);
    // save the match
    workQueue.add([SAVE]);

    queryResolver();
  }

  bool checkName(String name){
    if (match != null) {
      return match!.batters[match!.currentTeam].every((element) => element.name != name);
    }
    return false;
  }

  void goBack() async {
    bool? result = await displayDialog(
        'Do you want to quit the match? \n This match will be saved', context);
    if (result != null && result) {
      Navigator.pushNamedAndRemoveUntil(context, Util.mainPageRoute, (route) {
        // debugPrint(route.settings.name);
        return false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          // debugPrint(didPop.toString());
          // debugPrint("ue");
          bool? result = await displayDialog(
              'Do you want to quit the match? \n This match will be saved',
              context);
          viewModel.updateMatch(match!);
          if (result != null && result) {
            Navigator.pushNamedAndRemoveUntil(
                context, Util.homePage, (route) => false);
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: null,
                image: DecorationImage(
                    image: AssetImage('assests/background.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Scaffold(
                key: const Key("MatchPage"),
                backgroundColor: const Color(0x89000000),
                body: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 15),
                  child: ListView(
                    children: <Widget>[
                      Flex(
                        // Cannot add constant to this otherwise this will not reload on ball change
                        direction: Axis.vertical,
                        children: [
                          CardInfoScorer(key: Key("K1")),
                        ],
                      ),
                      Flex(
                          // Cannot add constant to this otherwise this will not reload on ball change
                          direction: Axis.vertical,
                          children: [
                            CardBalls(
                              key: Key("K2"),
                            ),
                          ]),
                      CardBatter(match!.currentBatters, true, null, false,checkName,
                          key: const Key("MatchPageBatter")),
                      CardBowler([match!.currentBowler!],
                          key: const Key("MatchPageBowler")),
                      CardScorer(updateScore, popScore, swap, retire, endInning,
                          key: const Key("Score1")),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : const SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }
}
