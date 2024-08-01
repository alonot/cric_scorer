import '../exports.dart';

class OnlineMatchesScreen extends StatefulWidget {
  const OnlineMatchesScreen({super.key});

  @override
  State<OnlineMatchesScreen> createState() => _OnlineMatchesScreenState();
}

class _OnlineMatchesScreenState extends State<OnlineMatchesScreen> {
  List<int> associatedIds = playArenaIds;

  TextEditingController editingController = TextEditingController();
  int selectedId = 0;
  final MatchViewModel viewModel = MatchViewModel();
  List<TheMatch>? matches;
  bool isLoading = false;
  int count = 0;

  @override
  void initState() {
    if (associatedIds.isEmpty) {
      selectedId = -1;
    } else {
      selectedId = associatedIds[0];
    }
    super.initState();
    fetchMatches();
  }

  void fetchMatches() async {
    if (selectedId != -1) {
      setState(() {
        isLoading = true;
      });
      matches = await viewModel
          .getOnlineMatches(selectedId); // We will fetch the matches
      count = matches!.length;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x52000000),
        leading: DropdownButton<int>(
          isExpanded: true,
          icon: const Icon(Icons.sort_rounded),
          elevation: 20,
          value: selectedId,
          underline: Container(),
          items: associatedIds
              .map((id) => DropdownMenuItem(
                    value: id,
                    child: Text(
                      " $id    ",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              // if (!playArenaIds[value]!) {
              //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not verified')));
              // }
              setState(() {
                selectedId = value;
              });
              fetchMatches();
            }
          },
        ),
        actions: [
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () {
                if (viewModel.isLoggedIn()) {
                  Navigator.pushNamed(context, OtherArena.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('You are not logged in.'),
                    action: SnackBarAction(
                        label: "Login",
                        onPressed: () {
                          Navigator.pushNamed(context, Util.signInOrUpRoute);
                        }),
                  ));
                }
              },
              child: Text('Play Arenas')),
        ],
      ),
      backgroundColor: const Color(0x89000000),
      body: Stack(
        children: !isLoading
            ? [
                Row(
                  children: [
                    TextField(
                      controller: editingController,
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (editingController.text.trim().isNotEmpty) {
                            try {
                              selectedId =
                                  int.parse(editingController.text.trim());
                              fetchMatches();
                            } on FormatException {}
                          }
                        },
                        child: Text('Find'))
                  ],
                ),
                (selectedId != -1)
                    ? ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, index) {
                          if (matches![index].currentBowler == null) {
                            viewModel.deleteMatch(matches![index].id!);
                            count -= 1;
                            matches?.removeAt(index);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                height: 180,
                                key: const Key("cont"),
                                child: CardMatch(
                                  onTap,
                                  uploadMatchDummy,
                                  setLoading,
                                  matches![index],
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      )
                    : const Center(
                        child: Text(
                        "Not Logged In",
                        style: TextStyle(color: Colors.white),
                      ))
              ]
            : <Widget>[
                  const SizedBox(
                    width: 0,
                    height: 0,
                  ),
                ] +
                [
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        )
                ],
      ),
    );
  }

  void uploadMatchDummy(bool a, int? b) {}

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onTap(bool hasWon, int? id) async {
    // debugPrint(hasWon.toString());
    if (id != null) {
      var match = await viewModel.getMatch(id);
      if (match != null) {
        viewModel.setCurrentMatch(match);

        // Util.batterNames = (await viewModel.getBatters(false))
        //     .map((batter) => batter.name)
        //     .toList();
        // Util.bowlerNames = (await viewModel.getBowlers(false))
        //     .map((bowler) => bowler.name)
        //     .toList();
      }
      if (hasWon) {
        Navigator.pushNamed(context, Util.scoreCardRoute);
      } else {
        // debugPrint("pushed");
        Navigator.pushNamed(context, Util.matchPageRoute);
      }
    }
  }
}
