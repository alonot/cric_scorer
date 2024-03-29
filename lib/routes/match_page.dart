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
    setState(() {
      isLoading = true;
      match!.currentBatters = List.of(match!.currentBatters.reversed);
    });

    if (match != null) {
      await viewModel.updateMatch(match!);
    }
    setState(() {
      isLoading = false;
    });
  }

  void retire() async {
    // retire the batter
    // match?.wickets[match!.currentTeam] +=1;
    await Navigator.pushNamed(context, Util.getBatterRoute)
        .then((value) => {setState(() {})});
  }

  void endInning() {
    // TODO : To end the inning
  }

  void updateScore(String s, String run) async {
    /**
     * Updates the score and calls other pages if needed.
     */
    bool needABowler = false;
    isLoading = true;
    setState(() {
      needABowler = match!.addScore(s, run);
    });
    bool doesInningChanged = false;
    /**
     * Check for end of innings
     */
    var cur = match!.currentTeam;
    if (match!.over_count[cur] >= match!.totalOvers ||
        (match!.wickets[cur] >= match!.no_of_players - 2 && run.contains("OUT")) ||
        (match!.inning == 2 && match!.score[cur] >= match!.score[(cur + 1) % 2]+1)) {
      // Call the openers . change the current Team index;
      if (match!.inning == 1) {
        Util.batterNames = (await viewModel.getBatters(false)).map((batter) => batter.name).toList();
        Util.bowlerNames = (await viewModel.getBowlers(false)).map((bowler) => bowler.name).toList();
        doesInningChanged = true;
      } else {
        // Match is Finished...
        if (match!.score[cur] >= match!.score[(cur + 1) % 2]+1) {
          Util.team = cur == 0 ? match!.team1 : match!.team2;
          Util.wonBy =
              "${match!.no_of_players - 1 - match!.wickets[cur]} wickets";
        } else if(match!.score[cur] != match!.score[(cur + 1) % 2]) {
          Util.team = cur == 0 ? match!.team2 : match!.team1;
          Util.wonBy =
              "${match!.score[(cur + 1) % 2] - match!.score[cur]} runs";
        }else{
          Util.team = "";
          Util.wonBy = "Nobody";
        }
        match!.hasWon = true;
        // debugPrint("${match!.inning} oversda");
      }
      // debugPrint("${match!.inning}awosnd1 ");
      // viewModel.updateMatch(match!);
    }

    if (run.contains("OUT")) {
      match!.wickets[match!.currentTeam] += 1;
      await Navigator.pushNamed(context, Util.wicketRoute)
          .then((value) => {setState(() {})});
    }

    if (match!.hasWon) {
      debugPrint("${match!.inning}awosnd");
      Navigator.pushNamed(context, Util.winnerPageRoute);
    } else if (doesInningChanged) {
      match!.inning = 2;
      match!.currentTeam++;
      match!.currentTeam %= 2;
      await Navigator.pushNamedAndRemoveUntil(context, Util.getOpenersRoute,
          (route) {
        // debugPrint(route.settings.name);
        return false;
      }).then((value) => setState(() {}));
    }

    /**
     * Calls the bowler page to get a new bowler
     */
    if (needABowler && !match!.hasWon) {
      await Navigator.pushNamed(context, Util.getBowlerRoute)
          .then((value) => {setState(() {})});
    }
    if (match != null) {
      // debugPrint("heres");
      await viewModel.updateMatch(match!);
      // debugPrint("jjsd");
    }

    setState(() {
      isLoading = false;
    });
  }

  void popScore() async {
    bool? result = await displayDialog('Are you sure?', context);
    if (result != null && !result){
      return;
    }

    isLoading = true;
    setState(() {
      bool result = match!.popScore();
      // debugPrint(result.toString());
      if (result) {
        goBack();
      }
    });
    if (match != null) {
      await viewModel.updateMatch(match!);
    }
    setState(() {
      isLoading = false;
    });
  }

  void goBack() async {
    bool? result =
        await displayDialog('Do you want to quit the match?', context);
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
          bool? result =
              await displayDialog('Do you want to quit the match?', context);
          if (result != null && result) {
            Navigator.pushNamedAndRemoveUntil(
                context, Util.mainPageRoute, (route) => false);
          }
        },
        child:Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: null,
                image: DecorationImage(
                    image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
              ),
              child: Scaffold(
                key: const Key("MatchPage"),
                backgroundColor: const Color(0x89000000),
                body: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 15),
                  child: ListView(
                    children: <Widget>[
                       Flex( // Cannot add constant to this otherwise this will not reload on ball change
                        direction: Axis.vertical,
                        children: [
                          CardInfoScorer(key: Key("K1")),
                        ],
                      ),
                       Flex(
                         // Cannot add constant to this otherwise this will not reload on ball change
                           direction: Axis.vertical, children: [
                        CardBalls(
                          key: Key("K2"),
                        ),
                      ]),
                      CardBatter(match!.currentBatters, true, null, false,
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
            isLoading? const CircularProgressIndicator() : const SizedBox(width: 0,height: 0,)
          ],
        ),
      ),
    );
  }
}
