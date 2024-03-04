

import 'package:cric_scorer/models/batter_stat.dart';
import 'package:cric_scorer/models/bowler_stat.dart';
import 'package:cric_scorer/models/match.dart';


class MatchRepository{
  TheMatch? _currentMatch;
  int battersCount = 0;
  int bowlersCount = 0;
  List<BatterStat>?  batters;
  List<BowlerStat>? bowlers;

  TheMatch? get currentMatch => _currentMatch;

  set currentMatch(TheMatch? value) {
    _currentMatch = value!;
  }
}