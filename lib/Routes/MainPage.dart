import 'package:cric_scorer/Components/CardMatch.dart';
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

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

  _MainPageState(){
    matches = null;
  }

  @override
  Widget build(BuildContext context) {
    if (matches == null) {
      matches = [];
      updateMatches();
    }else {
      count = matches!.length;
    }

    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: const Color(0x89000000),
            body: Stack(
              children: [
                !isLoading
                    ? ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, index) {
                          // debugPrint(index.toString());
                          // debugPrint(matches![index].id.toString());
                          if (matches![index].currentBowler == null) {
                            viewModel.deleteMatch(matches![index].id!);
                            count -= 1;
                            matches?.removeAt(index);
                          } else {
                            return Dismissible(
                                key: Key(matches![index].id.toString()),
                                direction: DismissDirection.horizontal,
                                onDismissed: (direction) {
                                  viewModel.deleteMatch(matches![index].id!);
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
                                      match: matches![index],
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
                !isLoading ?

                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          Util.batterNames = (await viewModel.getBatters()).map((e) => e.name).toList();
                          Util.bowlerNames = (await viewModel.getBowlers()).map((e) => e.name).toList();
                          Navigator.pushNamed(context, Util.homeRoute);
                        },
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(width: 0,height: 5,),
                      SizedBox(
                        width: 50,
                        child: Center(
                          child: MaterialButton(
                            elevation: 20,
                            height: 50,
                            color: Colors.pink.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),

                            onPressed: (){
                              Navigator.pushNamed(context, Util.statsRoute);
                            },
                            child: const Icon(Icons.sports_cricket),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    :const SizedBox(width: 0,height: 0,),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      )
              ],
            )));
  }

  void setLoading(bool value){
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
        Util.batterNames = (await viewModel.getBatters()).map((batter) => batter.name).toList();
        Util.bowlerNames = (await viewModel.getBowlers()).map((bowler) => bowler.name).toList();
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
      if (await AskPassword('Enter the Password', context) == "Pass") {
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

            match.uploaded = true;
            await viewModel.uploadMatch(match);
            await viewModel.updateMatch(match);
            setState(() {
              updateMatches();
            });
          }
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void updateMatches() async {
    setState(() {
      isLoading = true;
    });

    List<TheMatch> matchList = await viewModel.getAllMatches();
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
}
