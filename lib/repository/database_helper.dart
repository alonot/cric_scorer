import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../exports.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // singeleton instance
  static Database? _database;
  static Database? _loginDatabase;
  static Database? _playerDatabase;

  String matchTable = "match_table";
  String players = "players";
  String colId = 'id';
  String colTeam1 = 'team1';
  String colTeam2 = 'team2';
  String colTeam1url = 'team1url';
  String colTeam2url = 'team2url';
  String colToss = 'toss';
  String colOptTo = 'optTo';
  String colHasWon = 'hasWon';
  String colInning = 'inning';
  String colNoOfPlayers = 'no_of_players';
  String colTotalOvers = 'totalOvers';
  String colCurrentBatterIndex = 'currentBatterIndex';
  String colCurrentTeam = 'currentTeam';
  String colCurrentBowler = 'currentBowler';
  String colScore = 'score';
  String colWickets = 'wickets';
  String colOverCount = 'over_count';
  String colCurrentBatters = 'currentBatters';
  String colWicketOrder = 'wicketOrder';
  String colBatters = 'batters';
  String colBowlers = 'bowlers';
  String colPlayers = 'players';
  String colOvers = 'Overs';
  String colUploaded = 'uploaded';
  String colDate = 'date';

  /// User table
  String colLogin = 'email';
  String colPassword = 'password';

  /// player Table
  String playerTable = 'player_table';
  String colName = 'name';
  String colArenaId = 'ArenaId';
  String colPlayerInnings = 'innings';
  String colRuns = 'runs';
  String colBalls = 'balls';
  String colHighest = 'highest';
  String colBatAverage = 'Bataverage';
  String colBowlAverage = 'Bowlaverage';
  String colStrikeRate = 'strikeRate';
  String colFifties = 'fifties';
  String colHundreds = 'hundreds';
  String colThirtys = 'thirtys';
  String colEconomy = 'economy';
  String colBowlerRuns = 'bowlerRuns';
  String colPlyWickets = 'wickets';
  String colMatches = 'matches';

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  DatabaseHelper._createInstance();

  Future<Database> initializeDatabase() async {
    // get Directory path for both android and IOS to store the database
    // debugPrint("Instia");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "match.db");

//  open/ create db at this path
    var matchDatabase = openDatabase(path, version: 1, onCreate: _createdb);
    return matchDatabase;
  }

  Future<Database> initializeLoginDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "login.db");

    var loginDatabase =
        openDatabase(path, version: 1, onCreate: _createLoginDb);
    return loginDatabase;
  }

  Future<Database> initializePlayerDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "player.db");

    var playerDatabase =
        openDatabase(path, version: 2, onCreate: _createPlayerTable);
    return playerDatabase;
  }

  Future<Database> get login_database async {
    _loginDatabase ??= await initializeLoginDatabase();
    return _loginDatabase!;
  }

  Future<Database> get player_database async {
    _playerDatabase ??= await initializePlayerDatabase();
    return _playerDatabase!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  void _createLoginDb(Database db, int newVersion) async {
    await db
        .execute('CREATE TABLE login_table($colLogin TEXT,$colPassword TEXT)');
  }

  void _createPlayerTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $playerTable('
        '$colName TEXT PRIMARY KEY,'
        '$colArenaId INTEGER,'
        '$colPlayerInnings INTEGER,'
        '$colRuns INTEGER,'
        '$colBalls INTEGER,'
        '$colHighest INTEGER,'
        '$colBatAverage FLOAT,'
        '$colBowlAverage FLOAT,'
        '$colStrikeRate FLOAT,'
        '$colFifties INTEGER,'
        '$colHundreds INTEGER,'
        '$colThirtys INTEGER,'
        '$colEconomy FLOAT,'
        '$colBowlerRuns INTEGER,'
        '$colPlyWickets INTEGER,'
        '$colMatches INTEGER'
        ')');
  }

  void _createdb(Database db, int newVersion) async {
    // debugPrint("CreateDB");
    await db.execute('CREATE TABLE $matchTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTeam1 TEXT,'
        '$colTeam2 TEXT,'
        '$colTeam1url TEXT,'
        '$colTeam2url TEXT,'
        '$colToss TEXT,'
        '$colOptTo TEXT,'
        '$colHasWon TEXT,'
        '$colCurrentTeam INTEGER,'
        '$colInning INTEGER,'
        '$colCurrentBatterIndex INTEGER,'
        '$colTotalOvers INTEGER,'
        '$colNoOfPlayers INTEGER,'
        '$colCurrentBowler TEXT,'
        '$colScore TEXT,'
        '$colWickets TEXT,'
        '$colOverCount TEXT,'
        '$colCurrentBatters TEXT,'
        '$colWicketOrder TEXT,'
        '$colBatters TEXT,'
        '$colBowlers TEXT,'
        '$colPlayers TEXT,'
        '$colOvers TEXT,'
        '$colUploaded TEXT,'
        '$colDate TEXT'
        ')');
  }

  Future<Map<String, Object?>?> getCurrentLogin() async {
    Database db = await login_database;
    var result = await db.query('login_table').then((value) {
      return value.firstOrNull;
    });
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  Future<int> setCurrentUser(String email, String password) async {
    Database db = await login_database;

    var result = await db
        .insert('login_table', {colLogin: email, colPassword: password});
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllPlayers() async {
    Database db = await player_database;

    return await db.query(playerTable, orderBy: '$colName ASC');
  }

  // Returns a list of Map of the Database
  Future<List<Map<String, dynamic>>> getMatchesMaplst() async {
    Database db = await database;

    var result = await db.query(matchTable, orderBy: '$colDate DESC');

    return result;
  }

  Future<bool> addPlayer(Player p) async {
    Database db = await player_database;

    await db.insert(playerTable, p.toMap());

    return true;
  }

  Future<Map<String, dynamic>?> getAPlayer(String name) async {
    Database db = await player_database;

    return (await db
            .query(playerTable, where: '$colName = ?', whereArgs: [name]))
        .firstOrNull;
  }

  Future<TheMatch?> getMatch(int id) async {
    Database db = await database;
    debugPrint("here ${id}");
    var result = await db.rawQuery("SELECT * FROM match_table WHERE id = $id");
    if (result != []) {
      var result1 = TheMatch.fromMap(result[0]);
      return result1;
    } else {
      return null;
    }
  }

  // Insert a match
  Future<int> insertMatch(TheMatch match) async {
    Database db = await database;

    var result = await db.insert(matchTable, match.toMap());

    if (result == 0) {
      return -1;
    } else {
      Map<String, dynamic> result1 =
          (await db.query(matchTable, orderBy: "$colId DESC", limit: 1))[0];
      result = result1['id'];
      debugPrint("${result1['date']} ${result1['id']}");
    }

    return result;
  }

  // updates a match
  Future<int> updateMatch(TheMatch match) async {
    Database db = await database;
    var map = match.tolesserMap();
    map.remove('id');
    // debugPrint("Here ${match.id} ");
    var result = await db
        .update(matchTable, map, where: "$colId = ?", whereArgs: [match.id]);

    return result;
  }

  // updates a player
  Future<int> updatePlayer(Player player) async {
    Database db = await player_database;

    var ply = await getAPlayer(player.name);
    if (ply == null) {
      addPlayer(player);
    } else {
      var map = player.toMap();
      return await db.update(playerTable, map,
          where: "$colName = ?", whereArgs: [player.name]);
    }
    return 0;
  }

  Future<bool> updateLocalStats(TheMatch match) async {

    Map<String, Player> players = {};
    for (String player_name in match.players.keys){
      var ply = await getAPlayer(player_name);
      if (ply == null){
        players[player_name] = Player(player_name);
      }else{
        players[player_name] = Player.fromMap(ply);
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
      allSuccessFull &= (await updatePlayer(ply)) == 1;
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
    ply.strikeRate = (ply.strikeRate * ply.balls);
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

  // deletes a match
  Future<int> deleteMatch(int id) async {
    Database db = await database;

    var result =
        await db.rawDelete('DELETE FROM $matchTable WHERE $colId = $id');

    return result;
  }

  // get List<Matches> from list<Maps>
  Future<List<TheMatch>> getMatchesAsMatch() async {
    List<TheMatch> matches = [];

    var resultMap = await getMatchesMaplst();
    for (Map<String, dynamic> m in resultMap) {
      matches.add(TheMatch.fromMap(m));
    }

    return matches;
  }

  Future removeCurrentUser(String currentUser) async {
    var db = await login_database;
    debugPrint("currentUser : $currentUser");
    await db.delete("login_table",
        where: "$colLogin = ? ", whereArgs: [currentUser]);
  }
}
