import 'dart:ui';

import 'package:cric_scorer/models/Player.dart';

import 'exports.dart';

class MatchViewModel {
  MatchRepository _repository;
  DatabaseHelper _databaseHelper;
  static MatchViewModel? _viewModel; // singleton class

  /**
   * Creates a singleton instance of viewModel
   */
  MatchViewModel._createInstance(this._repository, this._databaseHelper);

  factory MatchViewModel() {
    var repository = MatchRepository();
    var databaseHelper = DatabaseHelper();
    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    _viewModel ??= MatchViewModel._createInstance(repository, databaseHelper);

    return _viewModel!;
  }

  bool isLoggedIn() => _repository.isSignedIn;

  void haveLoggedIn(){
    _repository.isSignedIn = true;
  }

  /// Gets the email and password of this user stored in db
  Future<Map<String, Object?>?> getCurrentLogin() async{
    var result = await _databaseHelper.getCurrentLogin();
    return result;
  }

  /// Sets the email and password of this user in db
  Future<int> setCurrentUser(String email,String password) async{
    var result = await _databaseHelper.setCurrentUser(email,password);
    return result;
  }

  /// Gets the current ongoing match
  TheMatch? getCurrentMatch() => _repository.currentMatch;

  /// Get the match with this particular id
  Future<TheMatch?> getMatch(int id) async {
    var result = await _databaseHelper.getMatch(id);
    return result;
  }

  /// Get all the players
  Future<void> getAllLocalPlayerName() async {
    var playersAsMap = await _databaseHelper.getAllPlayers();
    List<String> players = [];
    for (var ply in playersAsMap){
      players.add(ply['name']);
    }
    _repository.setPlayers(players);
  }

  Future<List<Player>> getAllPlayers() async {
    var playersAsMap = await _databaseHelper.getAllPlayers();
    List<Player> players = [];
    for (var ply in playersAsMap){
      players.add(Player.fromMap(ply));
    }
    return players;
  }

  List<String> getPlayers() {
    return _repository.players;
  }

  /// Get all the matches
  Future<List<TheMatch>> getAllMatches() async {
    var result = await _databaseHelper.getMatchesAsMatch();
    return result;
  }

  /// Delete this match from db
  Future<int> deleteMatch(int id) async {
    return await _databaseHelper.deleteMatch(id);
  }

  Future<int> updateMatch(TheMatch match) async {
    // debugPrint("${match.inning}IDini${match.id}");
    return await _databaseHelper.updateMatch(match);
  }

  Future<bool> updateLocalPlayersStats(TheMatch match) async {
    return await _databaseHelper.updateLocalStats(match);
  }

  Future<int> insertMatch(TheMatch match) async {
    int result = await _databaseHelper.insertMatch(match);
    return result;
  }

  /// Returns all the players present in the given arena Id (if this id exists)
  Future<List<Player>> getOnlinePlayers(int playArenaId) async {
    List<Player> players = [];
    final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(playArenaId.toString());
    final snapShot = await docPlayArena.get();
    if (snapShot.exists){
      final data = snapShot.data()!['players'];
      for (String playerId in data){
        final player = FirebaseFirestore.instance.collection('players').doc(playerId);
        final playerSnapShot = await player.get();
        if (playerSnapShot.exists){
          players.add(Player.fromMap(playerSnapShot.data()!));
        }
      }
    }
    return players;
  }


  /// sets the current Match
  bool setCurrentMatch(TheMatch match) {
    _repository.currentMatch = match;
    return true;
  }

  /// Gets all the online matches
  Future<List<TheMatch>> getOnlineMatches(int playArenaId) async  {
    List<TheMatch> matches = [];
    debugPrint("$LOGSTRING $playArenaId");
    final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(playArenaId.toString());
    final snapShot = await docPlayArena.get();
    if (snapShot.exists){
      final data = snapShot.data()!['matches'];
      for (String match_id in data){
        debugPrint("$LOGSTRING $match_id");
        final docMatch = FirebaseFirestore.instance.collection('matches').doc(match_id);
        final snapShotMatch = await docMatch.get();
        if (snapShotMatch.exists){
          matches.add(TheMatch.fromMap(snapShotMatch.data()!));
        }
      }
    }

    return matches;
  }


  /// To be called when reistering.
  /// This will create a unique PlayArenaId
  /// PlayArena : can be understood as a collection of matches and their stats
  /// base variable tells whether this playArenaId is base id of this user
  /// Each user may keep atmost 2 playArena : One which is created
  /// while regestering (here) and another he can manually add to hi profile.
  Future<int> uploadUser(String email,String uuid) async{

    final docUser = FirebaseFirestore.instance.collection('user').doc(uuid);
    var snapShot = await docUser.get();
    if (snapShot.exists){
      return -1;
    }

    int maximumId = 0;
    await FirebaseFirestore.instance.collection('playArena').get().then(
        (querySnapshot) {
          var playArenaDocs = querySnapshot.docs;
          for (var element in playArenaDocs) {
            maximumId = max(maximumId, int.parse(element.id));
          }
        }
    );
    maximumId ++;

    var newPlayArenaId = FirebaseFirestore.instance.collection('playArena').doc(maximumId.toString());
    newPlayArenaId.set({
      "matches":[], // holds reference to all the matches in this playArena
      "players":[] // holds reference to all the players played in this playArena.
    });
    final arenaAllowedDoc = newPlayArenaId.collection('allowed').doc(uuid);
    await arenaAllowedDoc.set({
      "val":true
    });


    await docUser.set({
      "email":email,
      "baseArena":maximumId,
    });
    // final playUserDoc = await docUser.collection('userPlayArena').doc();
    return maximumId;

  }

  Future<List<int>> getAllArenaIds(String uuid) async {
    var userDoc = await FirebaseFirestore.instance.collection('user').doc(uuid);
    var snapshot = await userDoc.get();
    List<int> playArenas = [];
    if (snapshot.exists){
      playArenas.add(snapshot.data()!['baseArena']);
      await userDoc.collection('userPlayArena').get().then(
              (querySnapshot) {
                for (var query  in querySnapshot.docs){
                    playArenas.add(int.parse(query.id));
                }
              }
      );
    }
    return playArenas;
  }

  /// logs out of the account
  Future logout() async {
    _repository.isSignedIn = false;
    uuid = "";
    await _databaseHelper.removeCurrentUser(currentUser);
  }


  /// Requests for permission
  /// 0 : arenaId does not exists
  /// -1 : user not loggedIn
  /// -2 : Already your base Arena Id
  /// 1 : successful
  Future<int> requestPlayArena(int arenaId) async {
    if (uuid == ""){
      return -1; // user not loggedIn
    }
    final docUser = await FirebaseFirestore.instance.collection('user').doc(uuid);
    final userSnapShot = await docUser.get();
    if (!userSnapShot.exists){
      return -1;
    }
    final baseId = userSnapShot.data()!['baseArena'];
    if (arenaId == baseId){
      return -2;
    }
    final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(arenaId.toString());
    final snapShot = await docPlayArena.get();
    if (snapShot.exists){
      final allowed = docPlayArena.collection('allowed').doc(uuid);
      await allowed.set({
        "val":false
      });
      return 1;
    }
    return 0; // id does not exists
  }

  /// Get All Attached uuids (pending or verified, both)
  /// // Output :
  /// key : email
  /// value : 0 : email
  ///         1 : verified
  Future<Map<String,List<dynamic>>> getAttachedAccouts() async{
    final docUser = await FirebaseFirestore.instance.collection('user').doc(uuid);
    final userSnapShot = await docUser.get();
    if (userSnapShot.exists){
      final baseArena = userSnapShot.data()!['baseArena'];
      final arenaDoc = FirebaseFirestore.instance.collection('playArena').doc(baseArena.toString());
      final snapShot = await arenaDoc.get();
      if (snapShot.exists){
        Map<String,List<dynamic>> finalList = {};
        await arenaDoc.collection('allowed').get().then(
            (querySnapShot) async {
              for (var query in querySnapShot.docs){
                final associatedUuid = query.id;
                final associatedUser = FirebaseFirestore.instance.collection('user').doc(associatedUuid);
                final associatedUserSnapshot = await associatedUser.get();
                if (associatedUserSnapshot.exists){
                  finalList[associatedUserSnapshot.data()!['email']] = [associatedUuid,query.data()['val']];
                }
              }

            }
        );
        finalList.remove(currentUser);
        return finalList;
      }
      return {};
    }
    return {};
  }

  /// remove playArenaId
  /// 1 : successfull
  /// 0: given id does not exists.
  /// -1: user not exists
  /// -2 : cannot remove base Id
  Future<int> removePlayArena(int arenaId) async {
    final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(arenaId.toString());
    final snapShot = await docPlayArena.get();
    if (snapShot.exists){
      final docUser = await FirebaseFirestore.instance.collection('user').doc(uuid);
      final userSnapShot = await docUser.get();
      if (userSnapShot.exists){

        final baseId = docUser.collection('userPlayArena').doc(arenaId.toString());
        await baseId.delete();

        final arenaDoc = docPlayArena.collection('allowed').doc(uuid);
        await arenaDoc.delete();

        return 1;
      }else{
        return -1;
      }
    }
    return 0;
  }

  /// Verifies playArenaId
  /// 1 : successfull
  /// 0: given id does not exists.
  /// -1: user not exists
  /// -2 :  new User does not exists
  Future<int> verifyUser(String new_uuid) async {
    final docUser = await FirebaseFirestore.instance.collection('user').doc(uuid);
    final userSnapShot = await docUser.get();
    if (userSnapShot.exists){
      final baseId = userSnapShot.data()!['baseArena'];
      final docNewUser = await FirebaseFirestore.instance.collection('user').doc(new_uuid);
      final newUserSnapShot = await docUser.get();
      if (!newUserSnapShot.exists){
        return -2; // new User does not exists
      }
      final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(baseId.toString());
      final snapShot = await docPlayArena.get();
      if (snapShot.exists){

        final newUserId = docNewUser.collection('userPlayArena').doc(baseId.toString());
        await newUserId.set({
          "uid" : uuid
        });

        final playArenaAllowed = docPlayArena.collection('allowed').doc(new_uuid);
        await playArenaAllowed.set({
          "val":true
        });

        return 1;
      }
      return 0; // arena Id does not exists(almost impossible)
    }
    return -1;
  }

  /// Unverifies playArenaId
  /// It is equal to removing the id
  /// 1 : successfull
  /// 0: given id does not exists.
  /// -1: user not exists
  /// -2 :  new User does not exists
  Future<int> unVerifyUser(String new_uuid) async {
    final docUser = await FirebaseFirestore.instance.collection('user').doc(uuid);
    final userSnapShot = await docUser.get();
    if (userSnapShot.exists){
      final baseId = userSnapShot.data()!['baseArena'];
      final docNewUser = await FirebaseFirestore.instance.collection('user').doc(new_uuid);
      final newUserSnapShot = await docNewUser.get();
      if (newUserSnapShot.exists){
        final userArenaDoc = docNewUser.collection('userPlayArena').doc(baseId.toString());
        await userArenaDoc.delete();
      }
      final docPlayArena = await FirebaseFirestore.instance.collection('playArena').doc(baseId.toString());
      final snapShot = await docPlayArena.get();
      if (snapShot.exists){
        final arenaDoc = docPlayArena.collection('allowed').doc(new_uuid);
        await arenaDoc.delete();
        return 1;
      }
      return 0; // arena Id does not exists(almost impossible)
    }
    return -1;
  }


  Future<Player?> getOnlinePlayer(String name, int playArenaId) async {
    if (playArenaId == -1){
      return null;
    }

    var docPlayer = await FirebaseFirestore.instance.collection('players').doc("${name}_$playArenaId");
    var snapShot = await docPlayer.get();
    if (snapShot.exists){
      return Player.fromMap(snapShot.data()!);
    }else{
      return null;
    }
  }

  /// Upsert a Player
  Future<bool> updateOnline(Player player,int playArenaId) async {
    var docPlayer = await FirebaseFirestore.instance.collection('players').doc("${player.name}_${player.ArenaId}");
    var snapShot = await docPlayer.get();
    if (!snapShot.exists){
      var docUser = await FirebaseFirestore.instance.collection('playArena').doc(playArenaId.toString());
      var snapShot = await docUser.get();
      if (!snapShot.exists){
        return false;
      }else{
        var data = snapShot.data()!;
        data['players'].add("${player.name}_${player.ArenaId}");
        docUser.update(data);
      }
    }
    docPlayer.set(player.toMap());
    return true;
  }

  /// updates the stats online
  Future<bool> updateStats(TheMatch match, int playArenaId) async {
    if (playArenaId == -1){
      return false;
    }
    Map<String, Player> players = {};
    for (String player_name in match.players.keys){
      var ply = await getOnlinePlayer(player_name, playArenaId);
      if (ply == null){
        players[player_name] = Player(player_name,ArenaId: playArenaId);
      }else{
        players[player_name] = ply;
      }
    }

    for (var batters in match.batters){
      for (var batter in batters){
        _updateBattingStats(batter, players[batter.name]!);
      }
    }

    for (var bowlers in match.bowlers){
      for (var bowler in bowlers){
        _updateBowlerStats(bowler, players[bowler.name]!);
      }
    }
    bool allSuccessFull = true;
    for (Player ply in players.values){
      allSuccessFull &= (await updateOnline(ply,playArenaId));
    }
    return allSuccessFull; // for later to add check whether operation was successfull

  }

  void _updateBattingStats(Batter batter, Player ply){
    if (batter.outBy != "Not Out"){
      ply.innings ++;
    }
    ply.balls += batter.balls;
    ply.runs += batter.runs;
    ply.highest = max(ply.highest, batter.runs);
    if (ply.innings != 0) {
      ply.Bataverage = ply.runs / ply.innings;
    }else{
      ply.Bataverage = ply.runs.toDouble();
    }
    ply.strikeRate = (ply.runs / ply.balls);
    if (batter.runs >= 100){
      ply.hundreds ++;
    }else if (batter.runs >=50){
      ply.fifties ++;
    }else if (batter.runs >= 30){
      ply.thirtys ++;
    }
  }
  void _updateBowlerStats(Bowler bowler, Player ply){
    ply.matches ++;
    ply.bowlerRuns += bowler.runs;
    ply.wickets += bowler.wickets;
    ply.economy = ((ply.economy * (ply.matches - 1)) + bowler.economy) / ply.matches;
    if (ply.wickets == 0){
      ply.Bowlaverage = ply.bowlerRuns.toDouble();
    }else{
      ply.Bowlaverage = ply.bowlerRuns / ply.wickets;
    }
  }


  /// Uploads the match online on the given playArenaId
  /// -1 : playArena not present
  /// -2 : not allowed
  /// -3 : unsuccessful
  Future<int> uploadMatch(TheMatch match,int playArenaId) async {
    if (match.uploaded){
      return 1;
    }
    // The rules on firebase check first whether this user is allowed for this playArena or not
    final docUser = await FirebaseFirestore.instance.collection('playArena').doc(playArenaId.toString());
    String id = FirebaseFirestore.instance.collection('matches').doc().id;
    final userSnapshot = await docUser.get();
    if (userSnapshot.exists){
      debugPrint("${LOGSTRING}p");
      final allowed = docUser.collection('allowed').doc(uuid);
      final allowedSnapshot = await allowed.get();
      if (!allowedSnapshot.exists){
        return -2;
      }else {
        if (!allowedSnapshot.data()!['val']){
          return -2;
        }
      }
      var data = userSnapshot.data()!['matches'];
      data.add(id);
      await docUser.update({"matches" :data});
    }else{
      return -1;
    }
    if (playArenaId == -1){
      return -3;
    }
    final docMatch = FirebaseFirestore.instance.collection('matches').doc(id);

    var matchMap = match.toMap();

    matchMap['playArena'] = playArenaId;
    await docMatch.set(matchMap);
    match.uploaded = true;

    if (await updateStats(match, playArenaId)){
      return 1;
    }
    return -3;

    // final batterCol = FirebaseFirestore.instance.collection('batters');
    // final bowlerCol = FirebaseFirestore.instance.collection('bowlers');
    //
    // final List<Batter> finalListBatter = [];
    // final List<Bowler> finalListBowler = [];
    //
    // // Converting batters to List
    // for (Batter batter in match.batters[0]) {
    //   var toAdd = batter;
    //   for (Batter b in finalListBatter) {
    //     if (b.name == batter.name) {
    //       if (b.runs > batter.runs) {
    //         toAdd = b;
    //       } else {
    //         toAdd = batter;
    //       }
    //       break;
    //     }
    //   }
    //   finalListBatter.add(toAdd);
    // }
    // for (Batter batter in match.batters[1]) {
    //   var toAdd = batter;
    //   for (Batter b in finalListBatter) {
    //     if (b.name == batter.name) {
    //       if (b.runs > batter.runs) {
    //         toAdd = b;
    //       } else {
    //         toAdd = batter;
    //       }
    //       break;
    //     }
    //   }
    //   finalListBatter.add(toAdd);
    // }
    //
    // // Converting Bowlers to List
    // for (Bowler bowler in match.bowlers[0]) {
    //   var toAdd = bowler;
    //   for (Bowler b in finalListBowler) {
    //     if (b.name == bowler.name) {
    //       if (b.wickets > bowler.wickets) {
    //         toAdd = b;
    //       } else {
    //         toAdd = bowler;
    //       }
    //       break;
    //     }
    //   }
    //   finalListBowler.add(toAdd);
    // }
    // for (Bowler bowler in match.bowlers[1]) {
    //   var toAdd = bowler;
    //   for (Bowler b in finalListBowler) {
    //     if (b.name == bowler.name) {
    //       if (b.wickets > bowler.wickets) {
    //         toAdd = b;
    //       } else {
    //         toAdd = bowler;
    //       }
    //       break;
    //     }
    //   }
    //   finalListBowler.add(toAdd);
    // }
    //
    // // debugPrint("Batters" + finalListBatter.toString());
    // // debugPrint("Bowlers" + finalListBowler.toString());
    //
    // // Updating all the batters stats, Before uploading this match
    // for (Batter b in finalListBatter) {
    //   // Update the player
    //   var docPlayer = batterCol.doc("${b.name}_$playArenaId");
    //   var snapShot = await docPlayer.get();
    //   Map<String, dynamic> newStats = {};
    //   if (snapShot.exists) {
    //     var data = snapShot.data()!;
    //
    //     if (data['I'] != null) {
    //       if(b.outBy == "Not Out") {
    //         newStats['I'] = data['I'];
    //       }else{
    //         newStats['I'] = (data['I'] + 1);
    //       }
    //       newStats['R'] = (data['R'] + b.runs);
    //       newStats['B'] = (data['B'] + b.balls);
    //       if(newStats['I'] == 0){
    //         newStats['Avg'] = newStats['R']!.toDouble();
    //       }else {
    //         newStats['Avg'] = (newStats['R']! / newStats['I']!);
    //       }
    //
    //       if (data['H'] < b.runs) {
    //         newStats['H'] = b.runs;
    //       } else {
    //         newStats['H'] = data['H'];
    //       }
    //
    //       newStats['SkR'] =newStats['R'] / newStats['B'];
    //
    //       newStats['thirties'] =
    //           data['thirties'] + b.runs >= 30 && b.runs < 50 ? 1 : 0;
    //       newStats['fifties'] =
    //           data['fifties'] + b.runs >= 50 && b.runs < 99 ? 1 : 0;
    //       newStats['hundreds'] = data['hundreds'] + b.runs >= 100 ? 1 : 0;
    //
    //       await docPlayer.update(newStats);
    //     }
    //   } else {
    //     if (b.outBy == "Not Out") {
    //       newStats['I'] = 0;
    //     }else{
    //       newStats['I'] = 1;
    //     }
    //     newStats['R'] = b.runs;
    //     newStats['B'] = b.balls;
    //     newStats['Avg'] = b.runs.toDouble();
    //     newStats['H'] = b.runs;
    //     if (b.balls == 0){
    //       newStats['SkR'] = 0.0;
    //     }else {
    //       newStats['SkR'] = b.strikeRate;
    //     }
    //     newStats['thirties'] = b.runs >= 30 && b.runs < 50 ? 1 : 0;
    //     newStats['fifties'] = b.runs >= 50 && b.runs < 99 ? 1 : 0;
    //     newStats['hundreds'] = b.runs >= 100 ? 1 : 0;
    //
    //     final player = batterCol.doc("${b.name}_$playArenaId");
    //     await player.set(newStats);
    //   }
    // }
    //
    // // Updating all the bowlers stats, Before uploading this match
    // for (Bowler b in finalListBowler) {
    //   final docPlayer = bowlerCol.doc("${b.name}_$playArenaId");
    //   // Update the player
    //   Map<String, dynamic> newStats = {};
    //   var snapShot = await docPlayer.get();
    //   if (snapShot.exists) {
    //     var data = snapShot.data();
    //     if (data?['M'] != null) {
    //       newStats['M'] = (data!['M'] + 1);
    //       newStats['W'] = (data['W'] + b.wickets);
    //       newStats['R'] = data['R'] + b.runs;
    //
    //       if (newStats['W'] != 0) {
    //         newStats['Avg'] = (newStats['R']! / newStats['W']!);
    //       } else {
    //         newStats['Avg'] = newStats['R']!.toDouble();
    //       }
    //
    //       newStats['Eco'] =
    //           ((data['Eco'] * data['M']) + b.economy) / newStats['M'];
    //     await docPlayer.update(newStats);
    //     }
    //   } else {
    //     newStats['M'] = 1;
    //     newStats['W'] = b.wickets;
    //     newStats['R'] = b.runs;
    //
    //     if (b.wickets != 0) {
    //       newStats['Avg'] = b.runs / b.wickets;
    //     } else {
    //       newStats['Avg'] = b.runs.toDouble();
    //     }
    //
    //     newStats['Eco'] = b.economy;
    //     final player = bowlerCol.doc("${b.name}_$playArenaId");
    //     await player.set(newStats);
    //   }
    // }
  }

}
