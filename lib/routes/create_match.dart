import '../exports.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({super.key});

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final MatchViewModel viewModel = MatchViewModel();
  late CardMatchSettings matchsetting;
  String _team1 = logos[0], _team2 = logos[1];
  String _team1Logo = "assests/${logos[0]}.jpg",
      _team2Logo = "assests/${logos[1]}.jpg";
  String? errorTextOver;
  String? errorTextPlayer;
  final TextEditingController oversController = TextEditingController();
  final TextEditingController noplayersController = TextEditingController();

  @override
  void initState() {
    loadBatterNBowler();
    super.initState();
  }

  void loadBatterNBowler() async {
    Util.batterNames =
        (await viewModel.getBatters(false)).map((e) => e.name).toList();
    Util.bowlerNames =
        (await viewModel.getBowlers(false)).map((e) => e.name).toList();
  }

  void update(String t1, String t2, String t3, String t4) {
    // debugPrint(t1 + t2 + t3 + t4);
    setState(() {
      _team1 = t1;
      _team2 = t2;
      _team1Logo = t3;
      _team2Logo = t4;
    });
  }

  void resetError() {
    setState(() {
      errorTextPlayer = null;
      errorTextOver = null;
    });
  }

  bool validate() {
    var allGood = true;
    if (oversController.text.isEmpty) {
      // print("yes");
      allGood = false;
      setState(() {
        errorTextOver = 'Required';
      });
    } else {
      // print("No ${oversController.text}");
      if (int.parse(oversController.text) > 450 ||
          int.parse(oversController.text) < 1) {
        allGood = false;
        setState(() {
          errorTextOver = "Range : 1 - 450";
          oversController.text = "";
        });
      } else {
        setState(() {
          errorTextOver = null;
        });
      }
    }

    if (noplayersController.text.isEmpty) {
      allGood = false;
      setState(() {
        errorTextPlayer = 'Required';
      });
    } else {
      if (int.parse(noplayersController.text) > 25 ||
          int.parse(noplayersController.text) < 3) {
        allGood = false;
        setState(() {
          errorTextPlayer = "Range : 3 - 25";
          noplayersController.text = "";
        });
      } else {
        setState(() {
          errorTextPlayer = null;
        });
      }
    }
    debugPrint("$_team1 ,,, $_team2");
    if (_team1 == _team2) {
      allGood = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar("Both names cannot be same!!!"));
    }
    if (_team1.isEmpty || _team2.isEmpty) {
      allGood = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar("Team name cannot be Empty!!!"));
    }
    return allGood;
  }

  @override
  Widget build(BuildContext context) {
    matchsetting = CardMatchSettings(
      _team1,
      _team2,
      errorTextOver,
      errorTextPlayer,
      oversController,
      noplayersController,
      resetError,
      key: const Key("supreb"),
    );

    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x89000000),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 10, right: 10, bottom: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    height: 180,
                    child: CardInfo(update, _team1, _team2),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    height: 350,
                    child: matchsetting,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint("Lets Play!!");
                          var randomError = "";
                          bool result = validate();
                          if (result) {
                            Map<String, String> info2 = matchsetting.getInfo();
                            // debugPrint("$_team1 ::: $_team2");
                            debugPrint(
                                "List : : ${logos} , ${_team1Logo} ${_team2Logo}");
                            TheMatch match = TheMatch(
                              _team1,
                              _team1Logo,
                              _team2,
                              _team2Logo,
                              info2['toss']!,
                              info2['optTo']!,
                              int.parse(noplayersController.text),
                              int.parse(oversController.text),
                            );
                            viewModel.setCurrentMatch(match);
                            _save(match);
                            Navigator.pushNamed(context, "Get Openers");
                          }
                          if (randomError.isNotEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(Util.getsnackbar(randomError));
                          }
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
                ],
              ),
            ),
          ),
        ));
  }

  void _save(TheMatch match) async {
    int result;
    result = await viewModel.insertMatch(match);
    if (result != -1) {
      // debugPrint("result${result}");
      match.id = result;
    }
    // print(result.toString()+"IDDDD");
  }
}
