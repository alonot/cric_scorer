

import 'package:cric_scorer/models/batter_stat.dart';
import 'package:cric_scorer/models/bowler_stat.dart';
import 'package:cric_scorer/models/match.dart';
import 'package:flutter/cupertino.dart';


class MatchRepository extends ChangeNotifier{
  TheMatch? currentMatch;
  int battersCount = 0;
  int bowlersCount = 0;
  List<BatterStat>?  batters;
  List<BowlerStat>? bowlers;
  int baseId = 0;
  bool isSignedIn = false;

  void setMatch(TheMatch match) async{
    currentMatch = match;
    notifyListeners();
  }
}