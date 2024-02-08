import 'package:cric_scorer/MatchViewModel.dart';
import 'package:cric_scorer/Routes/Home.dart';
import 'package:cric_scorer/Routes/GetBatter.dart';
import 'package:cric_scorer/Routes/GetBowler.dart';
import 'package:cric_scorer/Routes/GetOpeners.dart';
import 'package:cric_scorer/Routes/GetWicket.dart';
import 'package:cric_scorer/Routes/MatchPage.dart';
import 'package:cric_scorer/repository/MatchRepository.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';

void main() {
  var repository = MatchRepository();
  Util.viewModel = MatchViewModel(repository);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CricScorer',
      initialRoute: "New Match",
      routes: {
        "New Match": (context) => Home(),
        "Get Openers":(context) => GetOpeners(),
        "Get Bowler": (context) => GetBowler(),
        "Get Batter": (context) => GetBatter(),
        "Wicket":(context) => GetWicket(),
        "Match Page":(context) => MatchPage()
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
