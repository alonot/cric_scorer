

import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/repository/MatchRepository.dart';

class MatchViewModel{
  MatchRepository _repository;

  MatchViewModel(this._repository);

  TheMatch? getCurrentMatch() => this._repository.currentMatch;

  bool setCurrentMatch(TheMatch match) {
    print("here");
    _repository.currentMatch=match;
    return true;
  }
}