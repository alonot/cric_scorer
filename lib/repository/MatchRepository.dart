

import 'package:cric_scorer/models/BatterStat.dart';
import 'package:cric_scorer/models/BowlerStat.dart';
import 'package:cric_scorer/models/Match.dart';


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