import 'package:flutter/material.dart';

class Util {
  static SnackBar getsnackbar(String text) => SnackBar(
        backgroundColor: Colors.grey,
        content: Text(text),
      );

  static String homeRoute = "New Match";
  static String getOpenersRoute = "Get Openers";
  static String getBowlerRoute = "Get Bowler";
  static String getBatterRoute = "Get Batter";
  static String wicketRoute = "Wicket";
  static String matchPageRoute = "Match Page";
  static String mainPageRoute = "Main Page";
  static String winnerPageRoute = "Winner Page";
  static String scoreCardRoute = "ScoreCard";
  static String statsRoute = 'Stats';

  static String team = "";
  static String wonBy = "";
}

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
          backgroundColor: Color(0x89000000),
          title: Text(text),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("OK")),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel")),
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
          backgroundColor: Color(0x89000000),
          title: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            decoration: InputDecoration(hintText: 'Password'),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordCntrl,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, passwordCntrl.text),
                child: const Text("OK")),
            TextButton(
                onPressed: () => Navigator.pop(context, ""),
                child: const Text("Cancel")),
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
// TODO : Check for Available batter in
// TODO : in openers, in batters, // in bowlers page.
//  : Inetgrate the winner page.
// TODO : Same name check.
//  : add how got out in scoreCard

//  : stats Page
//  : FireBase backend
//  : integrate backend stats
