import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/models/batter.dart';
import 'package:cric_scorer/models/batter_stat.dart';
import 'package:cric_scorer/models/bowler.dart';
import 'package:cric_scorer/models/bowler_stat.dart';
import 'package:cric_scorer/models/match.dart';
import 'package:cric_scorer/repository/database_helper.dart';
import 'package:cric_scorer/repository/match_repository.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  Future<Map<String, Object?>?> getCurrentLogin() async{
    var result = await _databaseHelper.getCurrentLogin();
    return result;
  }

  Future<int> setCurrentUser(String email,String password) async{
    var result = await _databaseHelper.setCurrentUser(email,password);
    return result;
  }


  TheMatch? getCurrentMatch() => _repository.currentMatch;

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
    debugPrint("${match.inning}IDini${match.id}");
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

  Future<List<TheMatch>> getOnlineMatches(int id) async  {
    List<TheMatch> matches = [];
    await FirebaseFirestore.instance.collection('matches').get()
    .then((querySnapshot) {
      for(var doc in querySnapshot.docs){
        if (doc.data()['playArena'] == id){
          matches.add(TheMatch.fromMap(doc.data()));
        }
      }
    });
    return matches;
  }


  /// To be called when reistering.
  /// This will create a unique PlayArenaId
  /// PlayArena : can be scene as a collection of matches and their stats
  /// Each user may keep atmost 2 playArena : One which is created
  /// while regestering (here) and another he can manually add to hi profile.
  Future<int> uploadUser(String email) async{
    int maximumId = -9;
    await FirebaseFirestore.instance.collection('users').get().then(
        (querySnapshot) {
          for(var doc in querySnapshot.docs){
            if(doc.data()['playArena'] > maximumId){
              maximumId = doc.data()['playArena'];
            }
          }
        },
        onError: (e) => debugPrint("Error : $e")
    );
    var rng = Random();
    if(maximumId < 0){
      maximumId = rng.nextInt(1000);
    }
    maximumId ++;
    String id = FirebaseFirestore.instance.collection('user').doc().id;
    final docUser = FirebaseFirestore.instance.collection('user').doc(id);
    await docUser.set({
      "email":email,
      "playArena":maximumId,
      "verified":true
    });
    return maximumId;

  }

  /// This function checks if the given Id exist or not and then
  /// if exits then add it to the user table with verified = false
  /// User have to ask the owner of this playArenaId to verify him
  /// in order to use this playArenaId
  Future<bool> findnUploadUser(String email,int id) async{
    bool found = false;
    await FirebaseFirestore.instance.collection('user').get().then(
        (querySnapshot) {
          for(var doc in querySnapshot.docs){
            if(doc.data()['playArena'] == id){
              found = true;
              break;
            }
          }
        },
      onError: (e) => debugPrint("Error : $e")
    );
    if(found) {
      String id = FirebaseFirestore.instance.collection('user').doc().id;
      final docUser = FirebaseFirestore.instance.collection('user').doc(id);
      await docUser.set({
        "email" : email,
        "playArena" : id,
        "verified": false
      });
    }
    return found;
  }

  /// Returns A List<int> which contains the playArenaIds associated with this
  /// profile
  Future<Map<int,bool>> getPlayArenaIds(String email) async{
    Map<int,bool> ids = {};
    await FirebaseFirestore.instance.collection('user').get().then(
        (querySnapshot) {
          for(var doc in querySnapshot.docs){
            if(doc.data()['email'] == email){
              ids[doc.data()['playArena']] = (doc.data()['verified']);
            }
          }
        }
    );
    return ids;

  }


  /// Uploads the match online on the given playArenaId
  Future uploadMatch(TheMatch match,int playArenaId) async {
    String id = FirebaseFirestore.instance.collection('matches').doc().id;
    final docMatch = FirebaseFirestore.instance.collection('matches').doc(id);

    var matchMap = match.toMap();
    matchMap['playArena'] = playArenaId;
    await docMatch.set(matchMap);

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
    for (Bowler bowler in match.bowlers[0]) {
      var toAdd = bowler;
      for (Bowler b in finalListBowler) {
        if (b.name == bowler.name) {
          if (b.wickets > bowler.wickets) {
            toAdd = b;
          } else {
            toAdd = bowler;
          }
          break;
        }
      }
      finalListBowler.add(toAdd);
    }
    for (Bowler bowler in match.bowlers[1]) {
      var toAdd = bowler;
      for (Bowler b in finalListBowler) {
        if (b.name == bowler.name) {
          if (b.wickets > bowler.wickets) {
            toAdd = b;
          } else {
            toAdd = bowler;
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
      var docPlayer = batterCol.doc("${b.name}_$playArenaId");
      var snapShot = await docPlayer.get();
      Map<String, dynamic> newStats = {};
      if (snapShot.exists) {
        var data = snapShot.data()!;

        if (data['I'] != null) {
          if(b.outBy == "Not Out") {
            newStats['I'] = data['I'];
          }else{
            newStats['I'] = (data['I'] + 1);
          }
          newStats['R'] = (data['R'] + b.runs);
          newStats['B'] = (data['B'] + b.balls);
          if(newStats['I'] == 0){
            newStats['Avg'] = newStats['R']!.toDouble();
          }else {
            newStats['Avg'] = (newStats['R']! / newStats['I']!);
          }

          if (data['H'] < b.runs) {
            newStats['H'] = b.runs;
          } else {
            newStats['H'] = data['H'];
          }

          newStats['SkR'] =newStats['R'] / newStats['B'];

          newStats['thirties'] =
              data['thirties'] + b.runs >= 30 && b.runs < 50 ? 1 : 0;
          newStats['fifties'] =
              data['fifties'] + b.runs >= 50 && b.runs < 99 ? 1 : 0;
          newStats['hundreds'] = data['hundreds'] + b.runs >= 100 ? 1 : 0;

          await docPlayer.update(newStats);
        }
      } else {
        if (b.outBy == "Not Out") {
          newStats['I'] = 0;
        }else{
          newStats['I'] = 1;
        }
        newStats['R'] = b.runs;
        newStats['B'] = b.balls;
        newStats['Avg'] = b.runs.toDouble();
        newStats['H'] = b.runs;
        if (b.balls == 0){
          newStats['SkR'] = 0.0;
        }else {
          newStats['SkR'] = b.strikeRate;
        }
        newStats['thirties'] = b.runs >= 30 && b.runs < 50 ? 1 : 0;
        newStats['fifties'] = b.runs >= 50 && b.runs < 99 ? 1 : 0;
        newStats['hundreds'] = b.runs >= 100 ? 1 : 0;

        final player = batterCol.doc("${b.name}_$playArenaId");
        await player.set(newStats);
      }
    }

    for (Bowler b in finalListBowler) {
      final docPlayer = bowlerCol.doc("${b.name}_$playArenaId");
      // Update the player
      Map<String, dynamic> newStats = {};
      var snapShot = await docPlayer.get();
      if (snapShot.exists) {
        var data = snapShot.data();
        if (data?['M'] != null) {
          newStats['M'] = (data!['M'] + 1);
          newStats['W'] = (data['W'] + b.wickets);
          newStats['R'] = data['R'] + b.runs;

          if (newStats['W'] != 0) {
            newStats['Avg'] = (newStats['R']! / newStats['W']!);
          } else {
            newStats['Avg'] = newStats['R']!.toDouble();
          }

          newStats['Eco'] =
              ((data['Eco'] * data['M']) + b.economy) / newStats['M'];
        await docPlayer.update(newStats);
        }
      } else {
        newStats['M'] = 1;
        newStats['W'] = b.wickets;
        newStats['R'] = b.runs;

        if (b.wickets != 0) {
          newStats['Avg'] = b.runs / b.wickets;
        } else {
          newStats['Avg'] = b.runs.toDouble();
        }

        newStats['Eco'] = b.economy;
        final player = bowlerCol.doc("${b.name}_$playArenaId");
        await player.set(newStats);
      }
    }
  }


  Future<List<BatterStat>> getBatters(bool forceFetch, {int? id}) async {
    if (_repository.batters == null ||
        _repository.batters?.length != _repository.battersCount || forceFetch) {
      List<BatterStat> batters = [];
      var playArenaId = id?.toString();
      await FirebaseFirestore.instance.collection("batters").get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            var splittedName = docSnapshot.id.split('_');
            // debugPrint(splittedName.toString()  +":${playArenaId}");
            if ( playArenaId  != null && splittedName[1] == playArenaId) {
              batters.add(
                  BatterStat.fromMap(docSnapshot.data(), splittedName[0]));
            }else if (playArenaId == null){
              try {
                if (playArenaIds.keys.contains(int.parse(splittedName[1]))) {
                  batters.add(
                      BatterStat.fromMap(docSnapshot.data(), splittedName[0]));
                }
              }catch(e){}
            }
          }
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
      batters.sort((BatterStat b1, BatterStat b2) {
        if (b1.runs == b2.runs) {
          if (b1.highest < b2.highest) { // If highest is less then swap
            return 1; // 1 means swap
          } else {
            return -1;
          }
        } else if (b1.runs < b2.runs) {
          return 1;
        } else {
          return -1;
        }
      });
      _repository.battersCount = batters.length;
      _repository.batters = batters;
      return batters;
    } else {
      return _repository.batters!;
    }
  }

  Future<List<BowlerStat>> getBowlers(bool forceFetch, {int? id}) async {
    List<BowlerStat> bowlers = [];
    var playArenaId = id?.toString();
    if (_repository.bowlers != null ||
        _repository.bowlers?.length != _repository.bowlersCount || forceFetch) {
      await FirebaseFirestore.instance.collection("bowlers").get().then(
            (querySnapshot) {
          // debugPrint("Successfully completed ${querySnapshot.docs.length}");
          for (var docSnapshot in querySnapshot.docs) {
            var splittedName = docSnapshot.id.split('_');
            if ( playArenaId != null && splittedName[1] == playArenaId) {
              bowlers.add(BowlerStat.fromMap(
                  docSnapshot.data(), docSnapshot.id.split('_')[0]));
            }else if (playArenaId == null){
              try {
                if (playArenaIds.keys.contains(int.parse(splittedName[1]))) {
                  bowlers.add(BowlerStat.fromMap(
                      docSnapshot.data(), splittedName[0]));
                }
              }catch(e){}
            }
          }
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
      bowlers.sort(
              (BowlerStat b1,BowlerStat b2){
            if (b1.wickets==b2.wickets){
              if(b1.economy== b2.economy){
                if(b1.average == b2.average){
                  if (b1.matches > b2.matches){ // person with more matches is good.
                    return 1;
                  }else{
                    return -1;
                  }
                }else if(b1.average > b2.average){  // less avg is good
                  return 1; // 1 means swap
                }else{
                  return -1;
                }
              }else if (b1.economy > b2.economy){ // // less eco is good
                return 1;
              }else{
                return -1;
              }
            }else if (b1.wickets < b2.wickets){ // // more wickets is good
              return 1; // swap if wickets are less
            }else{
              return -1;
            }
          }
      );

      _repository.bowlers = bowlers;
      _repository.bowlersCount = bowlers.length;
    } else {
      bowlers = _repository.bowlers!;
    }
    return bowlers;
  }

}
