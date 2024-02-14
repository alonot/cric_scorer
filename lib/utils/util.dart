
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util{

  static SnackBar getsnackbar(String text) => SnackBar(backgroundColor: Colors.grey,content: Text(text),);


  static String homeRoute ="New Match";
  static String getOpenersRoute ="Get Openers";
  static String getBowlerRoute ="Get Bowler";
  static String getBatterRoute ="Get Batter";
  static String wicketRoute ="Wicket";
  static String matchPageRoute ="Match Page";
  static String mainPageRoute ="Main Page";
  static String winnerPageRoute ="Winner Page";
  static String scoreCardRoute ="ScoreCard";

  static String team = "";
  static String wonBy = "";
}


int timeNowMinutes(DateTime dt){
  /**
   * Number of minutes elapsed since 1 Jan 2024 00:00 .
   */
  return DateTime.parse(dt.toString()).difference(DateTime(2024,01,01)).inMinutes;

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


// TODO : stats Page
// TODO : FireBase backend
// TODO : integrate backend stats