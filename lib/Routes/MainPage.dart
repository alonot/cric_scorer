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

  @override
  Widget build(BuildContext context) {
    if (matches == null) {
      matches = [];
      updateMatches();
    }

    return Container(
        decoration: BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Color(0x89000000),
            floatingActionButton: !isLoading
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Util.homeRoute);
                    },
                    child: Center(
                      child: Icon(Icons.add),
                    ),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  ),
            body: Stack(
              children: [
                !isLoading
                    ? ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, index) {
                          debugPrint(index.toString());
                          debugPrint(matches![index].id.toString());
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
                                  matches!.removeAt(index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    height: 180,
                                    key: Key("cont"),
                                    child: CardMatch(
                                      onTap,
                                      uploadMatch,
                                      match: matches![index],
                                    ),
                                  ),
                                ));
                          }
                        },
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
                !isLoading ? FloatingActionButton(onPressed: (){

                },
                child: Icon(Icons.sports_cricket),
                ):SizedBox(width: 0,height: 0,),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      )
              ],
            )));
  }

  void onTap(bool hasWon, int? id) async {
    debugPrint(hasWon.toString());
    if (id != null) {
      var match = await viewModel.getMatch(id);
      if (match != null) {
        viewModel.setCurrentMatch(match);
      }
      if (hasWon) {
        Navigator.pushNamed(context, Util.scoreCardRoute);
      } else {
        debugPrint("pushed");
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
    if (matchList.length == 0) {
      debugPrint("No Match found");
    } else {
      setState(() {
        matches = matchList;
        count = matchList.length;
        debugPrint("Length:${matchList.length}");
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
