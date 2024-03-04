

import 'dart:io';

import 'package:cric_scorer/routes/home.dart';
import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/routes/create_match.dart';
import 'package:cric_scorer/routes/get_batter.dart';
import 'package:cric_scorer/routes/get_bowler.dart';
import 'package:cric_scorer/routes/get_opener.dart';
import 'package:cric_scorer/routes/get_wicket.dart';
import 'package:cric_scorer/routes/main_page.dart';
import 'package:cric_scorer/routes/match_page.dart';
import 'package:cric_scorer/Routes/scoreboard.dart';
import 'package:cric_scorer/Routes/stats.dart';
import 'package:cric_scorer/routes/sign_in_or_up_page.dart';
import 'package:cric_scorer/routes/winner_page.dart';
import 'package:cric_scorer/utils/util.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  var viewModel = MatchViewModel();
  Util.batterNames = (await viewModel.getBatters(true)).map((batter) => batter.name).toList();
  Util.bowlerNames = (await viewModel.getBowlers(true)).map((bowler) => bowler.name).toList();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
        exit(0);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint(error.toString()+ stack.toString());
    return true;
  };

  try {
    runApp(const MyApp());
  }
  on Exception{
    debugPrint('exception :$Exception');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CricScorer',
      initialRoute: Util.signInOrUpRoute,
      routes: {
        Util.homePage : (context) => const Home(),
        Util.createMatchRoute: (context) => const CreateMatch(),
        Util.getOpenersRoute: (context) => const GetOpeners(),
        Util.getBowlerRoute: (context) => const GetBowler(),
        Util.getBatterRoute: (context) => const GetBatter(),
        Util.wicketRoute: (context) => const GetWicket(),
        Util.matchPageRoute: (context) => const MatchPage(),
        Util.mainPageRoute: (context) => const MainPage(),
        Util.winnerPageRoute: (context) => const WinnerPage(),
        Util.scoreCardRoute: (context) => const Scoreboard(),
        Util.statsRoute: (context) => const Stats(),
        Util.signInOrUpRoute: (context) => const SignInPage(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
          fontFamily: 'Roboto',
          useMaterial3: true,
          textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: 'Roboto', color: Colors.white),
              displayMedium:
                  TextStyle(fontFamily: 'Roboto', color: Colors.white))),
    );
  }
}
