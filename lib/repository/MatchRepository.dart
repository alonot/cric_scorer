

import 'package:cric_scorer/models/Match.dart';

class MatchRepository{
  TheMatch? _currentMatch;

  TheMatch? get currentMatch => _currentMatch;

  set currentMatch(TheMatch? value) {
    _currentMatch = value!;
  }

}