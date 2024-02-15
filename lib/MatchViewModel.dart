

import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/repository/DatabaseHelper.dart';
import 'package:cric_scorer/repository/MatchRepository.dart';
import 'package:flutter/cupertino.dart';

class MatchViewModel{
  MatchRepository _repository;
  DatabaseHelper _databaseHelper;
  static MatchViewModel? _viewModel; // singleton class

  MatchViewModel._createInstance(this._repository,this._databaseHelper);

  factory MatchViewModel(){
    var repository = MatchRepository();
    var databaseHelper  = DatabaseHelper();
    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    _viewModel ??= MatchViewModel._createInstance(repository,databaseHelper);
    return _viewModel!;
  }

  TheMatch? getCurrentMatch() => this._repository.currentMatch;

  Future<TheMatch?> getMatch(int id) async{
    var result = await _databaseHelper.getMatch(id);
    return result;
  }

  Future<List<TheMatch>> getAllMatches() async {
    var result = await _databaseHelper.getMatchesAsMatch();
    return result;
  }

  Future<int> deleteMatch(int id) async {
    return await _databaseHelper.deleteMatch(id);
  }

  Future<int> updateMatch(TheMatch match) async {
    debugPrint(match.inning.toString()+"IDini"+match.id.toString());
    return await _databaseHelper.updateMatch(match);
  }

  Future<int> insertMatch(TheMatch match) async {
    return await _databaseHelper.insertMatch(match);
  }

  bool setCurrentMatch(TheMatch match) {
    // print("here");
    _repository.currentMatch=match;
    return true;
  }
}