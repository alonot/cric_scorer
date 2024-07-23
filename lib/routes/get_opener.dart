import '../exports.dart';

class GetOpeners extends StatefulWidget {
  const GetOpeners({super.key});

  @override
  State<GetOpeners> createState() => _GetOpenersState();
}

class _GetOpenersState extends State<GetOpeners> {
  final MatchViewModel viewModel = MatchViewModel();

  String batter1Name = "";
  String batter2Name = "";
  String bowlerName = "";

  String errorBatter1 = "";
  String errorBatter2 = "";
  String errorBowler = "";

  bool _validate() {
    bool allGood = true;

    if (batter1Name == batter2Name ||
        batter2Name == bowlerName ||
        batter1Name == bowlerName) {
      setState(() {
        errorBowler = 'Duplicate';
        errorBatter2 = 'Duplicate';
        errorBatter1 = 'Duplicate';
      });
      return false;
    }

    if (batter1Name.isEmpty) {
      allGood = false;
      setState(() {
        errorBatter1 = "required";
      });
    } else {
      setState(() {
        errorBatter1 = "";
      });
    }

    if (batter2Name.isEmpty) {
      allGood = false;
      setState(() {
        errorBatter2 = "required";
      });
    } else {
      setState(() {
        errorBatter2 = "";
      });
    }

    if (bowlerName.isEmpty) {
      allGood = false;
      setState(() {
        errorBowler = "required";
      });
    } else {
      setState(() {
        errorBowler = "";
      });
    }
    return allGood;
  }

  void setbowlerName(String val) => bowlerName = val;

  void setbatter1Name(String val) => batter1Name = val;

  void setbatter2Name(String val) => batter2Name = val;

  void onPlayBtnClicked() async {
    // debugPrint("Lets Play!2!",);
    var randomError = "";
    bool result = _validate();
    // print(result);
    if (result) {
      var match = viewModel.getCurrentMatch();
      if (match == null) {
        Navigator.pop(context);
      }
      // debugPrint("get:::: ${match!.team1} ${match!.team2}");
      Bowler bowler = Bowler(bowlerName);
      Batter batter1 = Batter(batter1Name);
      Batter batter2 = Batter(batter2Name);
      match!.addBowler(bowler);
      match.currentBatters = [];
      match.addBatter(batter1);
      match.addBatter(batter2);
      match.Overs[match.currentTeam].add(Over(bowler.name, [batter1.name]));
      // debugPrint(match.team1);
      Util.batterNames.remove(batter1.name);
      Util.batterNames.remove(batter2.name);
      // await viewModel.updateMatch(match);
      Navigator.pushNamedAndRemoveUntil(
          context, Util.matchPageRoute, (route) => false);
    }
    if (randomError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        content: Text(randomError),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(children: [
                Card(
                  elevation: 20,
                  color: Colors.transparent,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text('Batter1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                          AutoCompleteIt(
                            Util.batterNames,
                            setbatter1Name,
                            key: const Key("Batter1 Opener"),
                          ),
                          Text(
                            errorBatter1,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontFamily: 'Roboto'),
                            textAlign: TextAlign.start,
                          ),
                          const Text('Batter2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                          AutoCompleteIt(
                            Util.batterNames,
                            setbatter2Name,
                            key: const Key("Batter2 Opener"),
                          ),
                          Text(errorBatter2,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                          const Text('Bowler',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                          AutoCompleteIt(
                            Util.bowlerNames,
                            setbowlerName,
                            key: const Key("Bowler Opener"),
                          ),
                          Text(errorBowler,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontFamily: 'Roboto'),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        onPlayBtnClicked();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0x42A4E190))),
                      child: const Text(
                        "Let's Play!!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
