import 'package:flutter/rendering.dart';

import '../exports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MatchViewModel viewModel = MatchViewModel();
  List<TheMatch>? matches;
  bool isLoading = false;
  int count = 0;

  _MainPageState() {
    matches = null;
  }

  @override
  Widget build(BuildContext context) {
    if (matches == null) {
      matches = [];
      updateMatches();
    } else {
      count = matches!.length;
    }

    return Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Text(currentUser,style: TextStyle(color: Colors.white60),)),
          backgroundColor: const Color(0x89000000),
          actions: [
            IconButton(
                onPressed: () {
                  viewModel.logout();
                  currentUser = "";
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      Util.signInOrUpRoute,
                      (route) => (route.settings.name == Util.signInOrUpRoute)
                          ? true
                          : false);
                },
                icon: const Icon(Icons.power_settings_new))
          ],
        ),
        floatingActionButton: !isLoading
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, Util.createMatchRoute);
                },
                child: const Center(
                  child: Icon(Icons.add),
                ),
              )
            : const SizedBox(),
        backgroundColor: const Color(0x89000000),
        body: Stack(
          children: [
            !isLoading
                ? ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      if (matches![index].currentBowler == null) {
                        viewModel.deleteMatch(matches![index].id!);
                        count -= 1;
                        matches?.removeAt(index);
                      } else {
                        return Dismissible(
                            key: Key(matches![index].id.toString()),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {

                              TheMatch deletedMatch = matches![index];
                              final _snackBar = SnackBar(content: Text("Match deleted"),
                                action: SnackBarAction(label: 'Undo', onPressed: () {
                                  setState(() {
                                  matches!.add(deletedMatch);
                                  });
                                },),);
                              ScaffoldMessenger.of(context)
                              .showSnackBar(_snackBar).closed.then((value) {
                                if (value != SnackBarClosedReason.action){
                                  viewModel.deleteMatch(deletedMatch.id!);
                                }
                              });

                              setState(() {
                                matches!.removeAt(index);
                                count = matches!.length;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                height: 180,
                                key: const Key("cont"),
                                child: CardMatch(
                                  onTap,
                                  uploadMatch,
                                  setLoading,
                                  matches![index],
                                ),
                              ),
                            ));
                      }
                      return null;
                    },
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ));
  }

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
        // Util.batterNames = (await viewModel.getBatters(false)).map((batter) => batter.name).toList();
        // Util.bowlerNames = (await viewModel.getBowlers(false)).map((bowler) => bowler.name).toList();
      }
      if (hasWon) {
        Navigator.pushNamed(context, Util.scoreCardRoute);
      } else {
        // debugPrint("pushed");
        Navigator.pushNamed(context, Util.matchPageRoute);
      }
    }
  }

  void uploadMatch(bool hasWon, int? id) async {
    if (!hasWon) {
      ScaffoldMessenger.of(context).showSnackBar(
          Util.getsnackbar("Can't upload .Match is Not Over Yet!!"));
    } else {
      // if (await AskPassword('Enter the Password', context) == "Pass") {
      //
      // }
      setState(() {
        isLoading = true;
      });
      if (id != null) {
        var match = await viewModel.getMatch(id);
        if (match != null) {
          if (match.uploaded) {
            ScaffoldMessenger.of(context)
                .showSnackBar(Util.getsnackbar("Match Already uploaded"));
            return;
          }

          dialogBeforeUpload(match);
        }
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void updateMatches() async {
    setState(() {
      isLoading = true;
    });

    List<TheMatch> matchList = await viewModel.getAllMatches();
    await viewModel.getAllLocalPlayerName();
    players = viewModel.getPlayers();
    if (matchList.isEmpty) {
      debugPrint("No Match found");
    } else {
      setState(() {
        matches = matchList;
        count = matchList.length;
        // debugPrint("Length:${matchList.length}");
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void dialogBeforeUpload(TheMatch match) async {
    if (viewModel.isLoggedIn()) {
      await showDialog<int?>(
          context: context,
          builder: (context) {
            int? groupValue = playArenaIds[0];
            TextEditingController passwordCntrl = TextEditingController();
            return AlertDialog(
              backgroundColor: const Color(0xC3000000),
              title: const Text(
                'Please Select a playArenaId',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                height: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:

                    playArenaIds
                            .map<Widget>((val) =>ListTile(
                      visualDensity:
                      const VisualDensity(vertical: -4),
                      title: Text(
                        val.toString(),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      leading: Radio<int>(
                        value: val,
                        groupValue: groupValue,
                        onChanged: (val) {
                            setState(() {
                              groupValue = val;
                            });
                        },
                      ),
                    ),)
                            .toList() +
                        [
                          // TextField(
                          //   decoration: const InputDecoration(
                          //       hintText: 'Password',
                          //       hintStyle: TextStyle(color: Colors.white)),
                          //   keyboardType: TextInputType.visiblePassword,
                          //   obscureText: true,
                          //   controller: passwordCntrl,
                          // ),
                        ]),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // if (passwordCntrl.text != "pass") {
                      //   groupValue = null;
                      // }
                      return Navigator.pop(context, groupValue);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          }).then((value) async {
        if (value != null) {
          setState(() {
            isLoading = true;
          });
          await viewModel.uploadMatch(match, value)
          .then((result) {
            if (result == -1){
              ScaffoldMessenger.of(context)
                  .showSnackBar(Util.getsnackbar('PlayArena Id not present'));
            }else if (result == -2){
              ScaffoldMessenger.of(context)
                  .showSnackBar(Util.getsnackbar('not allowed. Please request for permission in the play Arena tab.'));
            }else if (result == 1){
              ScaffoldMessenger.of(context)
                  .showSnackBar(Util.getsnackbar('Match uploaded successfully'));
            }
          }
          );
          await viewModel.updateMatch(match);
          setState(() {
            updateMatches();
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something Went Wrong')));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('You are not logged in.'),
        action: SnackBarAction(
            label: "Login",
            onPressed: () {
              Navigator.pushNamed(context, Util.signInOrUpRoute);
            }),
      ));
    }
  }
}
