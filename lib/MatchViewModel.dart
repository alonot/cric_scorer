import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:cric_scorer/models/Match.dart';
import 'package:cric_scorer/repository/DatabaseHelper.dart';
import 'package:cric_scorer/repository/MatchRepository.dart';
import 'package:flutter/cupertino.dart';

class MatchViewModel {
  MatchRepository _repository;
  DatabaseHelper _databaseHelper;
  static MatchViewModel? _viewModel; // singleton class

  MatchViewModel._createInstance(this._repository, this._databaseHelper);

  factory MatchViewModel() {
    var repository = MatchRepository();
    var databaseHelper = DatabaseHelper();
    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    _viewModel ??= MatchViewModel._createInstance(repository, databaseHelper);
    return _viewModel!;
  }

  TheMatch? getCurrentMatch() => this._repository.currentMatch;

  Future<TheMatch?> getMatch(int id) async {
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
    debugPrint(match.inning.toString() + "IDini" + match.id.toString());
    return await _databaseHelper.updateMatch(match);
  }

  Future<int> insertMatch(TheMatch match) async {
    int result = await _databaseHelper.insertMatch(match);
    return result;
  }

  bool setCurrentMatch(TheMatch match) {
    // print("here");
    _repository.currentMatch = match;
    return true;
  }

  Future uploadMatch(TheMatch match) async {
    String id = FirebaseFirestore.instance.collection('matches').doc().id;
    final docMatch = FirebaseFirestore.instance.collection('matches').doc(id);
    // debugPrint("Heres");
    await docMatch.set(match.toMap());
    // debugPrint("pasod");
    final batterCol = FirebaseFirestore.instance.collection('batters');
    final bowlerCol = FirebaseFirestore.instance.collection('bowlers');

    final List<Batter> finalListBatter = [];
    final List<Bowler> finalListBowler = [];

    for (Batter batter in match.batters[0]) {
      var toAdd = batter;
      for (Batter b in finalListBatter) {
        if (b.name == batter.name) {
          if (b.runs > batter.runs) {
            toAdd = b;
          } else {
            toAdd = batter;
          }
          break;
        }
      }
      finalListBatter.add(toAdd);
    }
    for (Batter batter in match.batters[1]) {
      var toAdd = batter;
      for (Batter b in finalListBatter) {
        if (b.name == batter.name) {
          if (b.runs > batter.runs) {
            toAdd = b;
          } else {
            toAdd = batter;
          }
          break;
        }
      }
      finalListBatter.add(toAdd);
    }
    for (Bowler batter in match.bowlers[0]) {
      var toAdd = batter;
      for (Bowler b in finalListBowler) {
        if (b.name == batter.name) {
          if (b.runs > batter.runs) {
            toAdd = b;
          } else {
            toAdd = batter;
          }
          break;
        }
      }
      finalListBowler.add(toAdd);
    }
    for (Bowler batter in match.bowlers[1]) {
      var toAdd = batter;
      for (Bowler b in finalListBowler) {
        if (b.name == batter.name) {
          if (b.runs > batter.runs) {
            toAdd = b;
          } else {
            toAdd = batter;
          }
          break;
        }
      }
      finalListBowler.add(toAdd);
    }

    // debugPrint("Batters" + finalListBatter.toString());
    // debugPrint("Bowlers" + finalListBowler.toString());

    for (Batter b in finalListBatter) {
      // Update the player
      var docPlayer = batterCol.doc(b.name);
      var snapShot = await docPlayer.get();
      Map<String, double> newStats = {};
      if (snapShot.exists) {
        var data = snapShot.data()!;
        if (data['I'] != null) {
          newStats['I'] = data['I'] + 1;
          newStats['R'] = data['R'] + b.runs;
          newStats['Avg'] = (newStats['R']! / newStats['I']!);
          if (data['H'] > b.runs) {
            newStats['H'] = b.runs.toDouble();
          } else {
            newStats['H'] = data['H'];
          }
          newStats['Sk.R'] =
              ((data['Sk.R'] * newStats['I']) + b.strikeRate) / newStats['I'];
        }
        await docPlayer.update(newStats);
      } else {
        newStats['I'] = 1;
        newStats['R'] = b.runs.toDouble();
        newStats['Avg'] = b.runs.toDouble();
        newStats['H'] = b.runs.toDouble();
        newStats['Sk.R'] = b.strikeRate;
        final player = batterCol.doc(b.name);
        await player.set(newStats);
      }
    }

    for (Bowler b in finalListBowler) {
      final docPlayer = bowlerCol.doc(b.name);
      // Update the player
      Map<String, double> newStats = {};
      var snapShot = await docPlayer.get();
      if (snapShot.exists) {
        var data = snapShot.data();
        if (data?['M'] != null) {
          newStats['M'] = data!['M'] + 1;
          newStats['W'] = data['W'] + b.wickets;
          newStats['R'] = data['R'] + b.runs.toDouble();

          if(newStats['W'] != 0) {
            newStats['Avg'] = (newStats['R']! / newStats['W']!);
          }else{
            newStats['Avg'] = newStats['R']!;

          }
          newStats['Eco'] =
              ((data['Eco'] * data['M']) + b.economy) / newStats['M'];
        }
        await docPlayer.update(newStats);
      } else {
        newStats['M'] = 1;
        newStats['W'] = b.wickets.toDouble();
        newStats['R'] = b.runs.toDouble();
        if (b.wickets != 0) {
          newStats['Avg'] = b.runs / b.wickets;
        }else {
          newStats['Avg'] = b.runs.toDouble();
        }
        newStats['Eco'] = b.economy;
        final player = bowlerCol.doc(b.name);
        await player.set(newStats);
      }
    }
  }
}
