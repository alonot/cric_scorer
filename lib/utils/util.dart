import 'dart:math';

import 'package:cric_scorer/models/Player.dart';
import 'package:flutter/material.dart';

class Util {
  static SnackBar getsnackbar(String text) => SnackBar(
        backgroundColor: Colors.grey,
        content: Text(text),
      );
  static TextStyle text_style = TextStyle(fontFamily: 'Roboto',color: Colors.white);

  static String createMatchRoute = "New Match";
  static String homePage = "home Match";
  static String getOpenersRoute = "Get Openers";
  static String getBowlerRoute = "Get Bowler";
  static String getBatterRoute = "Get Batter";
  static String wicketRoute = "Wicket";
  static String matchPageRoute = "Match Page";
  static String mainPageRoute = "Main Page";
  static String winnerPageRoute = "Winner Page";
  static String scoreCardRoute = "ScoreCard";
  static String statsRoute = 'Stats';
  static String signInOrUpRoute = 'SignInOrUp';

  static String team = "";
  static String wonBy = "";
  static List<String> batterNames = [];
  static List<String> bowlerNames = [];
}

const String LOGSTRING = "CRIC-SCORER :";
const String UPDATE = "update";
const String POP = "pop";
const String RETIRE = "retire";
const String SWAP = "swap";
const String END = "end";
const String CHECKOVER = "over";
const String GETBOWLER = "bowler";
const String CHECKWINNER = "winner";
const String CHECKINNING = "inning";
const String SAVE = "save";
const String WICKET = "wicket";
const int SCORE_MIN = -99999;

int getTotal(List<int> points){
  int maxABat = max(points[0],points[1]);
  int maxABowl = max(points[2],points[3]);
  int total = 0;
  total += (maxABat == SCORE_MIN) ? 0 : maxABat;
  total += (maxABowl == SCORE_MIN) ? 0 : maxABowl;
  return total;
}

String currentUser="";
String uuid = "";
List<int> playArenaIds = [];

List<String> players= [];
Map<int,List<Player>> onlinePlayers = {};

List<String> logos = [
  "RCB","CSK","RR","MI","PK","DC","LSG","GT","SRH","KKR"
];

int timeNowMinutes(DateTime dt) {
  /**
   * Number of minutes elapsed since 1 Jan 2024 00:00 .
   */
  return DateTime.parse(dt.toString())
      .difference(DateTime(2024, 01, 01))
      .inMinutes;
}

Future<bool?> displayDialog(String text, BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0x89000000),
          title: Text(text,style: const TextStyle(color: Colors.white),),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("OK",style: TextStyle(color: Colors.white),)),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
          ],
        );
      });
}

Future<String?> AskPassword(String text, BuildContext context) async {
  return showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController passwordCntrl = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color(0xCA000000),
          title: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Password'),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordCntrl,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, passwordCntrl.text),
                child: const Text("OK",style: TextStyle(color: Colors.white),)),
            TextButton(
                onPressed: () => Navigator.pop(context, ""),
                child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
          ],
        );
      });
}

//  : add new page that contains all the previous matches and a floating button
//  : Fetch matches from backend for Main Page
//  : Connect the database.
//  : Add A winner page.
//  : Add a backend.
//  : To fetch stats/players from the backend.
//  : backend checking
//  : Remove concept of focus node
// : delete match functionality
//  : ScoreCard
//  : Load previous match
//  : a winner trophy in the scoreCard.
//  : Fall Of wickets
//  : Check for Available batter in
//  : in openers, in batters, // in bowlers page.
//  : Inetgrate the winner page.
//  : Same name check.
// : Pdf generation
// TODO : DLS if possible
//  : add how got out in scoreCard

//  : stats Page
//  : FireBase backend
//  : integrate backend stats
