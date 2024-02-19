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
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyABNonH-Zf7LLr7hkohyU13czg3iioYN9U", // paste your api key here
      appId:
      "1:1089318839183:android:cbbd9f89c06f7a627621fa", //paste your app id here
      messagingSenderId: "1089318839183", //paste your messagingSenderId here
      projectId: "cricscorer-e4157", //paste your project id here
    ),

  );

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
          ),
          displayMedium: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white
          )
        )
      ),
    );
  }
}
