
import 'package:cric_scorer/MatchViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util{
  static RoundedRectangleBorder cardborder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)));

  static SnackBar getsnackbar(String text) => SnackBar(backgroundColor: Colors.grey,content: Text(text),);

  static MatchViewModel? viewModel;
  static bool validateOvers = false;
  static bool validateNoOfPlayers = false;

  static String homeRoute ="New Match";
  static String getOpenersRoute ="Get Openers";
  static String getBowlerRoute ="Get Bowler";
  static String getBatterRoute ="Get Batter";
  static String wicketRoute ="Wicket";
  static String matchPageRoute ="Match Page";
  static String mainPageRoute ="Main Page";
  static String winnerPageRoute ="Winner Page";

  static String team = "";
  static String wonBy = "";
}


enum BowlType{
  WIDE,LEGAL,NOBALL,LEGBYE,BYE
}


//  : add new page that contains all the previous matches and a floating button
// TODO : Fetch matches from backend for Main Page
// TODO : Connect the database.
//  : Add A winner page.
// TODO : Add a backend.
// TODO : To fetch stats/players from the backend.
// TODO : Check for Available batter in
// TODO : in openers, in batters, in bowlers page.
//  : Inetgrate the winner page.
// TODO : Same name check.