import 'dart:io';

import 'package:cric_scorer/models/Match.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // singeleton instance
  static Database? _database;

  String matchTable = "match_table";
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
  String colOvers = 'Overs';
  String colDate = 'date';

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  DatabaseHelper._createInstance();

  Future<Database> initializeDatabase() async {
    // get Directory path for both android and IOS to store the database
    debugPrint("Instia");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "match.db");

//  open/ create db at this path
    var matchDatabase = openDatabase(path, version: 1, onCreate: _createdb);
    return matchDatabase;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  void _createdb(Database db, int newVersion) async {
    debugPrint("CreateDB");
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
        '$colOvers TEXT,'
        '$colDate TEXT'
        ')');
  }

  // Returns a list of Map of the Database
  Future<List<Map<String, dynamic>>> getMatchesMaplst() async {
    Database db = await this.database;

    var result = await db.query(matchTable, orderBy: '$colDate ASC');
    debugPrint("Matches ${result.toString()}");
    return result;
  }

  Future<TheMatch?> getMatch(int id) async {
    Database db = await this.database;
    debugPrint("here ${id}");
    var result = await db.rawQuery("SELECT * FROM match_table WHERE id = $id");
    if (result != []){
      var result1 = TheMatch.fromMap(result[0]);
      return result1;
    }
    else {
      return null;
    }
  }

  // Insert a match
  Future<int> insertMatch(TheMatch match) async {
    Database db = await this.database;

    var result = await db.insert(matchTable, match.toMap());
    
    if (result  == 0){
      return -1;
    }else{
      Map<String,dynamic> result1 = (await db.query(matchTable,orderBy: "$colId DESC",limit: 1))[0];
      result = result1['id'];
    }

    return result;
  }

  // updates a match
  Future<int> updateMatch(TheMatch match) async {
    Database db = await this.database;
    var map =match.tolesserMap();
    map.remove('id');
    debugPrint("Here ${match.id}");
    var result = await db.update(matchTable, map,where: "$colId = ?",whereArgs: [match.id]);

    return result;
  }
  
  // deletes a match
  Future<int> deleteMatch(int id) async{
    Database db = await this.database;
    
    var result = await db.rawDelete('DELETE FROM $matchTable WHERE $colId = $id');

    return result;
  }

  // get List<Matches> from list<Maps>
  Future<List<TheMatch>> getMatchesAsMatch() async{
    List<TheMatch> matches = [];

    var resultMap = await getMatchesMaplst();
    for(Map<String,dynamic> m in resultMap){
      matches.add(TheMatch.fromMap(m));
    }

    return matches;
  }


}
