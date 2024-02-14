import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/Routes/Home.dart';
import 'package:cric_scorer/Routes/GetBatter.dart';
import 'package:cric_scorer/Routes/GetBowler.dart';
import 'package:cric_scorer/Routes/GetOpeners.dart';
import 'package:cric_scorer/Routes/GetWicket.dart';
import 'package:cric_scorer/Routes/MainPage.dart';
import 'package:cric_scorer/Routes/MatchPage.dart';
import 'package:cric_scorer/Routes/Scoreboard.dart';
import 'package:cric_scorer/Routes/WinnerPage.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

void main() {
  MatchViewModel();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CricScorer',
      initialRoute: Util.mainPageRoute,
      routes: {
        Util.homeRoute: (context) => Home(),
        Util.getOpenersRoute:(context) => GetOpeners(),
        Util.getBowlerRoute: (context) => GetBowler(),
        Util.getBatterRoute: (context) => GetBatter(),
        Util.wicketRoute:(context) => GetWicket(),
        Util.matchPageRoute:(context) => MatchPage(),
        Util.mainPageRoute:(context) => MainPage(),
        Util.winnerPageRoute:(context) => WinnerPage(),
        Util.scoreCardRoute:(context) => Scoreboard(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        fontFamily: 'Roboto',

        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white
          )
        )
      ),
    );
  }
}
