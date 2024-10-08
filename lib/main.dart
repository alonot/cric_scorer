

import 'exports.dart';

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
        OtherArena.id : (context) => const OtherArena(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
          fontFamily: 'Roboto',
          useMaterial3: true,
          textTheme: const TextTheme(
            titleMedium: TextStyle(fontFamily: 'Roboto', color: Colors.white),
            titleLarge: TextStyle(fontFamily: 'Roboto', color: Colors.white),
            titleSmall: TextStyle(fontFamily: 'Roboto', color: Colors.white),
              bodyLarge: TextStyle(fontFamily: 'Roboto', color: Colors.white),
              bodyMedium:
                  TextStyle(fontFamily: 'Roboto', color: Colors.white))),
          color: Colors.white,
    );
  }
}
