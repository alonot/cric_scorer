
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
}



enum BowlType{
  WIDE,LEGAL,NOBALL,LEGBYE,BYE
}