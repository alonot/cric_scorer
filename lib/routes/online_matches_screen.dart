import 'package:cric_scorer/Components/card_match.dart';
import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/models/match.dart';
import 'package:flutter/material.dart';

import 'package:cric_scorer/utils/util.dart';

class OnlineMatchesScreen extends StatefulWidget {
  const OnlineMatchesScreen({super.key});

  @override
  State<OnlineMatchesScreen> createState() => _OnlineMatchesScreenState();
}

class _OnlineMatchesScreenState extends State<OnlineMatchesScreen> {
  List<int> associatedIds = playArenaIds.keys.toList();
  int selectedId = 0;
  final MatchViewModel viewModel = MatchViewModel();
  List<TheMatch>? matches;
  bool isLoading = false;
  int count = 0;


  @override
  void initState() {
    selectedId = associatedIds[0];
    matches = null ; // We will fetch the matches only
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0x52000000) ,
            leading: SizedBox(
              width: 200,
              height: 30,
              child: DropdownButton<int>(
                icon: const Icon(Icons.sort_rounded),
                elevation: 20,
                value: selectedId,
                underline: Container(),
                items: associatedIds
                    .map((id) => DropdownMenuItem(
                  value: id,
                  child: Text(" $id    ",style: TextStyle(color: Colors.red),),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedId = value!;
                  });
                },
              ),
            ),
          ),
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
                              uploadMatchDummy,
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
        ));
  }

  void uploadMatchDummy(bool a, int? b){

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
        Util.batterNames = (await viewModel.getBatters(false)).map((batter) => batter.name).toList();
        Util.bowlerNames = (await viewModel.getBowlers(false)).map((bowler) => bowler.name).toList();
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
