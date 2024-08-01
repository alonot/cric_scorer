
import 'package:cric_scorer/components/PlayerCard.dart';

import '../exports.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  final MatchViewModel viewModel =  MatchViewModel();
  List<MapEntry<String,List<int>>> player_entries = [];
  List<Batter> battersTeam1 = [];
  List<Batter> battersTeam2 = [];
  List<Bowler> bowlersTeam1 = [];
  List<Bowler> bowlersTeam2 = [];
  var wicketOrder1=[[]];
  var wicketOrder2=[[]];
  String team1="";
  String team2="";
  String score1="0-0";
  String score2 = "0-0";
  String overs1 = "0.0";
  String overs2 = "0.0";
  int isSelected = 0;
  String toDisplay = "1st innings";



  @override
  Widget build(BuildContext context) {
    TheMatch match = viewModel.getCurrentMatch()!;
    player_entries = match.players.entries.toList();
    player_entries.sort((MapEntry<String,List<int>> a ,MapEntry<String,List<int>> b) {
      int totalA = getTotal(a.value);
      int totalB = getTotal(b.value);
      if (totalA > totalB){
        return -1;
      }else if (totalA == totalB){
        return 0;
      }else {
        return 1;
      }
    });
    battersTeam1 = match.batters[0];
    battersTeam2 = match.batters[1];
    bowlersTeam1 = match.bowlers[0];
    bowlersTeam2 = match.bowlers[1];
    wicketOrder1=match.wicketOrder[0];
    wicketOrder2=match.wicketOrder[1];
    team1 = match.team1;
    team2 = match.team2;
    score1 = "${match.score[0]}-${match.wickets[0]}";
    score2 = "${match.score[1]}-${match.wickets[1]}";
    overs1 = "${match.over_count[0].toStringAsFixed(1)} OVERS";
    overs2 = "${match.over_count[1].toStringAsFixed(1)} OVERS";
    var cur = match.currentTeam;
    if (match.hasWon){
      if (match.score[cur] >= match.score[(cur + 1) % 2]) {
        var team = cur == 0 ? match.team1 : match.team2;
        toDisplay ="$team won by ${(match.no_of_players - 1 - match.wickets[cur]).toString()} Wickets";
      } else {
        var team = cur == 0 ? match.team2 : match.team1;
        toDisplay ="$team won by ${(match.score[(cur + 1) % 2] - match.score[cur] ).toString()} runs";
      }
    }else if(match.inning == 2){
      var team = cur == 0 ? match.team1 : match.team2;
      String needrun =
          (match.score[(cur + 1) % 2] - match.score[cur] + 1).toString();
      int curBalls =
          ((match.over_count[cur] * 10).toInt() ~/ 10 * 6) +
              ((match.over_count[cur] * 10).toInt() % 10).toInt();
      int total = (match.totalOvers * 10).toInt();
      int totalBalls = ((total ~/ 10 * 6).toInt() + total % 10);
      String needfrom = (totalBalls - curBalls).toString();
      toDisplay = "$team needs $needrun runs from $needfrom balls";
    }


    return SafeArea(
        top: true,
        minimum: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
      decoration: const BoxDecoration(
        border: null,
        image: DecorationImage(
            image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x89000000),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top:50 ),
          child: ListView(
            children: [
              ListTile(
                title: const Text("ScoreCard",style: TextStyle(color: Colors.blueGrey,fontSize: 22,),textAlign: TextAlign.center,),
                titleAlignment: ListTileTitleAlignment.center,
                subtitle: Text(toDisplay,style: const TextStyle(color: Colors.redAccent,),textAlign: TextAlign.center,),
              ),
              Column(
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey
                      )
                    ),
                    onTap: (){
                      setState(() {
                        if (isSelected == 0){
                          isSelected = -1;
                        }else {
                          isSelected = 0;
                        }
                      });
                    },
                    tileColor: isSelected == 1 ? Colors.transparent :Colors.grey,
                    leading: Text(team1,style: const TextStyle(color: Colors.white,fontSize: 15),),
                    title: Text(score1,style: const TextStyle(color: Colors.white),),
                    trailing: Text(overs1,style: const TextStyle(color: Colors.white),),
                  ),
                  isSelected == 0 ? CardBatter(battersTeam1, false, (p0) => null,true,null):const SizedBox(width: 0 ,height: 0,),
                  isSelected == 0 ? CardBowler(bowlersTeam1):const SizedBox(width: 0 ,height: 0,),
                  isSelected == 0 ? FallOfWickets(wicketOrder1, (wicketOrder1.length)):const SizedBox(width: 0 ,height: 0,),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey
                        )
                    ),
                    onTap: (){
                      setState(() {
                        if (isSelected == 1){
                          isSelected = -1;
                        }else {
                          isSelected = 1;
                        }
                      });
                    },
                    tileColor: isSelected == 0 ? Colors.transparent :Colors.grey,
                    leading: Text(team2,style: const TextStyle(color: Colors.white,fontSize: 15),),
                    title: Text(score2,style: const TextStyle(color: Colors.white),),
                    trailing: Text(overs2,style: const TextStyle(color: Colors.white),),
                  ),
                  isSelected == 1 ?
                  CardBatter(battersTeam2, false, (p0) => null,true,null):const SizedBox(width: 0,height: 0,),
                  isSelected == 1 ? CardBowler(bowlersTeam2):const SizedBox(width: 0,height: 0,),
                  isSelected == 1 ? FallOfWickets(wicketOrder2, wicketOrder2.length):const SizedBox(width: 0 ,height: 0,),
                ],
              ),
              Container(
                height: 50,
                child: Center(child: Text('Match Points')),
              )
            ] + player_entries.map((e) {
              var innings = e.value;
              int total_points = getTotal(e.value);
              return PlayerCard(e.key, e.value,
                  total_points);
            }).toList(),
          ),
        ),
      ),
    ));
  }
}
