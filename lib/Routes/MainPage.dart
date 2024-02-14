import 'package:cric_scorer/Components/CardMatch.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/MatchViewModel.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MatchViewModel viewModel = MatchViewModel();
  List<TheMatch>? matches;
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Util.homeRoute);
              },
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
            body: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                debugPrint(index.toString());
                debugPrint(matches![index].id.toString());
                if (matches![index].currentBowler == null){
                  viewModel.deleteMatch(matches![index].id!);
                  count -=1;
                  matches?.removeAt(index);
                }else{
                return Dismissible(key: Key(matches![index].id.toString()),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction){
                    viewModel.deleteMatch(matches![index].id!);
                      matches!.removeAt(index);
                    },
                    child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    height: 180 ,
                    key: Key("cont"),
                    child: CardMatch(
                      onTap,
                      match: matches![index],
                    ),
                  ),
                ));}
              },
            )));
  }

  void onTap(bool hasWon,int? id) async{
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

  void updateMatches() async {
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
  }
}
