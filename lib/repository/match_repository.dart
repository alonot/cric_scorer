
import 'package:cric_scorer/models/Player.dart';

import '../exports.dart';


class MatchRepository extends ChangeNotifier{
  TheMatch? currentMatch;
  List<String> players = [];
  bool isSignedIn = false;

  void setMatch(TheMatch match) async{
    currentMatch = match;
    notifyListeners();
  }

  void setPlayers(List<String> plys){
    players = plys;
    notifyListeners();
  }
}